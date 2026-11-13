local M = {}

local preview_ns = vim.api.nvim_create_namespace("harper_review_preview")

local function harper(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" })[1]
end

local function sorted(bufnr, ns, rule)
  local list = vim.tbl_filter(function(d)
    return d.user_data and d.user_data.lsp and (not rule or d.code == rule)
  end, vim.diagnostic.get(bufnr, { namespace = ns }))
  table.sort(list, function(a, b)
    return a.lnum < b.lnum or (a.lnum == b.lnum and a.col < b.col)
  end)
  return list
end

-- Returns the first problem past the position and how many remain from it.
local function after(list, lnum, col)
  for i, d in ipairs(list) do
    if d.lnum > lnum or (d.lnum == lnum and d.col > col) then
      return d, #list - i + 1
    end
  end
end

local function at_or_after_cursor(list)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for i, d in ipairs(list) do
    if d.lnum == row and d.col <= col and col < d.end_col then
      return d, #list - i + 1
    end
  end
  return after(list, row, col - 1)
end

-- Harper's edits only touch the document they were requested for.
local function text_edits(action)
  local edit = action and action.edit
  if not edit then
    return nil
  end
  local _, edits = next(edit.changes or {})
  if edits then
    return edits
  end
  local change = (edit.documentChanges or {})[1]
  return change and change.edits
end

local function changed_lines(bufnr, encoding, action)
  local edits = text_edits(action)
  if not edits or #edits == 0 then
    return nil
  end
  local first, last = math.huge, 0
  for _, e in ipairs(edits) do
    first = math.min(first, e.range.start.line)
    last = math.max(last, e.range["end"].line)
  end
  local old = vim.api.nvim_buf_get_lines(bufnr, first, last + 1, false)
  local scratch = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(scratch, 0, -1, false, old)
  vim.lsp.util.apply_text_edits(
    vim.tbl_map(function(e)
      local r = e.range
      return {
        newText = e.newText,
        range = {
          start = { line = r.start.line - first, character = r.start.character },
          ["end"] = {
            line = r["end"].line - first,
            character = r["end"].character,
          },
        },
      }
    end, edits),
    scratch,
    encoding
  )
  local new = vim.api.nvim_buf_get_lines(scratch, 0, -1, false)
  vim.api.nvim_buf_delete(scratch, { force = true })
  return old, new
end

local function continuation(s, i)
  local b = s:byte(i)
  return b ~= nil and b >= 0x80 and b < 0xC0
end

local function wordy(s, i)
  local b = s:byte(i)
  return b ~= nil and (b >= 0x80 or s:sub(i, i):match("[%w_]") ~= nil)
end

-- Byte columns where two lines differ: a[from, a_to) became b[from, b_to).
local function differing(a, b)
  local from = 0
  while from < #a and from < #b and a:byte(from + 1) == b:byte(from + 1) do
    from = from + 1
  end
  while from > 0 and continuation(a, from + 1) do
    from = from - 1
  end
  local tail = 0
  while
    tail < #a - from
    and tail < #b - from
    and a:byte(#a - tail) == b:byte(#b - tail)
  do
    tail = tail + 1
  end
  while tail > 0 and continuation(a, #a - tail + 1) do
    tail = tail - 1
  end
  return from, #a - tail, #b - tail
end

local function in_word(s, i)
  return wordy(s, i) and wordy(s, i + 1)
end

-- Like differing, but widened to whole words when the change starts or ends
-- inside one, since a one-letter change is easy to miss.
local function changed_words(a, b)
  local from, a_to, b_to = differing(a, b)
  if in_word(a, from) or in_word(b, from) then
    while from > 0 and wordy(a, from) do
      from = from - 1
    end
  end
  if in_word(a, a_to) or in_word(b, b_to) then
    -- Both lines end with the same text after the change.
    while wordy(a, a_to + 1) do
      a_to, b_to = a_to + 1, b_to + 1
    end
  end
  return from, a_to, b_to
end

local function cells(s)
  return vim.api.nvim_strwidth(s)
end

local function is_space(c)
  return c:find("^%s") ~= nil
end

-- The end of s in at most n cells, starting at a word when it can.
local function keep_end(s, n)
  if s == "" or cells(s) <= n then
    return s
  end
  local cs = vim.fn.split(s, [[\zs]])
  local i, used = #cs + 1, cells("…")
  while i > 1 and used + cells(cs[i - 1]) <= n do
    i = i - 1
    used = used + cells(cs[i])
  end
  if i > 1 and not is_space(cs[i - 1]) then
    local j = i
    while j <= #cs and not is_space(cs[j]) do
      j = j + 1
    end
    i = j <= #cs and j or i
  end
  while i <= #cs and is_space(cs[i]) do
    i = i + 1
  end
  return "…" .. table.concat(cs, "", i)
end

-- The start of s in at most n cells, ending at a word when it can.
local function keep_start(s, n)
  if s == "" or cells(s) <= n then
    return s
  end
  local cs = vim.fn.split(s, [[\zs]])
  local i, used = 0, cells("…")
  while i < #cs and used + cells(cs[i + 1]) <= n do
    i = i + 1
    used = used + cells(cs[i])
  end
  if i < #cs and not is_space(cs[i + 1]) then
    local j = i
    while j > 0 and not is_space(cs[j]) do
      j = j - 1
    end
    i = j > 0 and j or i
  end
  while i > 0 and is_space(cs[i]) do
    i = i - 1
  end
  return table.concat(cs, "", 1, i) .. "…"
end

-- Trims the text on either side of a change to fit n cells, so the change
-- stays in view on long lines.
local function around(before, changes, rest, n)
  local room = n
  for _, c in ipairs(changes) do
    room = math.min(room, n - cells(c))
  end
  if cells(before) + cells(rest) <= room then
    return before, rest
  end
  before = keep_end(
    before,
    math.min(cells(before), math.max(math.floor(room / 3), room - cells(rest)))
  )
  return before, keep_start(rest, room - cells(before))
end

-- Splits s into lines of at most n cells at spaces.
local function wrap(s, n)
  local lines, line = {}, nil
  for word in s:gmatch("%S+") do
    if line and cells(line) + 1 + cells(word) <= n then
      line = line .. " " .. word
    else
      lines[#lines + 1] = line
      line = word
    end
  end
  lines[#lines + 1] = line or ""
  return lines
end

-- Most Harper fixes are one edit inside one line: returns that line, the
-- byte columns [from, to) the edit replaces, and its new text.
local function line_edit(bufnr, encoding, action)
  local edits = text_edits(action)
  local e = edits and #edits == 1 and edits[1]
  if
    not e
    or e.range.start.line ~= e.range["end"].line
    or e.newText:find("\n")
  then
    return nil
  end
  local line = vim.api.nvim_buf_get_lines(
    bufnr,
    e.range.start.line,
    e.range.start.line + 1,
    false
  )[1]
  if not line then
    return nil
  end
  return line,
    vim.str_byteindex(line, encoding, e.range.start.character, false),
    vim.str_byteindex(line, encoding, e.range["end"].character, false),
    e.newText
end

-- Preview lines plus extmarks { row, col, opts } for one menu item, fitted
-- to n cells where possible. Tabs become single spaces so byte columns
-- still line up.
local function render(ctx, d, item, n)
  local encoding = ctx.client.offset_encoding
  local line, from, to, text
  if item.action then
    line, from, to, text = line_edit(ctx.bufnr, encoding, item.action)
  end
  if line then
    line, text = line:gsub("\t", " "), text:gsub("\t", " ")
    -- Diff only the replaced text, so a match just outside it cannot shift
    -- the highlight.
    local replaced = line:sub(from + 1, to)
    local i, was_to, now_to = changed_words(replaced, text)
    local was, now = replaced:sub(i + 1, was_to), text:sub(i + 1, now_to)
    local before, rest = around(
      line:sub(1, from) .. replaced:sub(1, i),
      { was, now },
      replaced:sub(was_to + 1) .. line:sub(to + 1),
      n
    )
    local col = 2 + #before
    return { "- " .. before .. was .. rest, "+ " .. before .. now .. rest }, {
      { 0, 0, { end_col = 1, hl_group = "Removed" } },
      { 1, 0, { end_col = 1, hl_group = "Added" } },
      { 0, col, { end_col = col + #was, hl_group = "DiffDelete" } },
      { 1, col, { end_col = col + #now, hl_group = "DiffAdd" } },
    }
  end

  local old, new
  if item.action then
    old, new = changed_lines(ctx.bufnr, encoding, item.action)
  end
  if old then
    local lines, marks = {}, {}
    for _, l in ipairs(old) do
      lines[#lines + 1] = "- " .. l
    end
    for _, l in ipairs(new) do
      lines[#lines + 1] = "+ " .. l
    end
    for row = 0, #lines - 1 do
      local removed = row < #old
      marks[#marks + 1] =
        { row, 0, { end_col = 1, hl_group = removed and "Removed" or "Added" } }
      marks[#marks + 1] =
        { row, 0, { line_hl_group = removed and "DiffDelete" or "DiffAdd" } }
    end
    return lines, marks
  end

  line = (
    vim.api.nvim_buf_get_lines(ctx.bufnr, d.lnum, d.lnum + 1, false)[1] or ""
  ):gsub("\t", " ")
  to = d.end_lnum == d.lnum and math.max(d.end_col, d.col) or #line
  local problem, rest = line:sub(d.col + 1, to), line:sub(to + 1)
  if cells(problem) > n then
    problem, rest = keep_start(problem, n), ""
  end
  local before
  before, rest = around(line:sub(1, d.col), { problem }, rest, n)
  local col = 2 + #before
  return { "  " .. before .. problem .. rest }, {
    { 0, col, { end_col = col + #problem, hl_group = "DiffText" } },
  }
end

local function pick(ctx, d, left, items, on_choice)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  -- The list is only as wide as its longest entry and the preview gets the
  -- rest, tall enough for the wrapped message and the change. Telescope
  -- calls these again when the editor is resized.
  local list = 30
  for _, item in ipairs(items) do
    list = math.max(list, cells(item.key .. "  " .. item.title) + 4)
  end
  local share = 0.9
  local function preview_width(width)
    return width - math.min(list, math.floor(width / 2)) - 4
  end
  local layout = {
    width = share,
    preview_width = function(_, width)
      return preview_width(width)
    end,
    -- Borders and the prompt take 4 rows. The preview holds the message, a
    -- blank line, and the two changed lines.
    height = function(_, columns)
      local message =
        wrap(d.message, preview_width(math.floor(columns * share)))
      return math.max(#items + 4, #message + 5)
    end,
    preview_cutoff = 0,
  }

  local chosen
  require("telescope.pickers")
    .new(require("telescope.themes").get_cursor({ layout_config = layout }), {
      prompt_title = ("Harper · %d left"):format(left),
      initial_mode = "normal",
      finder = require("telescope.finders").new_table({
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            ordinal = item.title,
            display = item.key .. "  " .. item.title,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = require("telescope.previewers").new_buffer_previewer({
        title = d.code,
        define_preview = function(self, entry)
          local win, buf = self.state.winid, self.state.bufnr
          local n = vim.api.nvim_win_get_width(win)
          local lines = wrap(d.message, n)
          lines[#lines + 1] = ""
          local top = #lines
          local change, marks = render(ctx, d, entry.value, n - 2)
          vim.list_extend(lines, change)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          for _, m in ipairs(marks) do
            vim.api.nvim_buf_set_extmark(
              buf,
              preview_ns,
              top + m[1],
              m[2],
              m[3]
            )
          end
          vim.wo[win].wrap = true
          vim.wo[win].linebreak = true
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        -- Every way out of the picker (a choice, <Esc>, focus loss) wipes the
        -- prompt buffer.
        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = prompt_bufnr,
          once = true,
          callback = function()
            vim.schedule(function()
              on_choice(chosen)
            end)
          end,
        })
        local function choose(item)
          chosen = item
          actions.close(prompt_bufnr)
        end
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          choose(entry and entry.value)
        end)
        for _, item in ipairs(items) do
          if item.key ~= " " then
            map("n", item.key, function()
              choose(item)
            end, { desc = item.title })
          end
        end
        return true
      end,
    })
    :find()
end

-- Walks Harper's problems from the cursor down in a Telescope popup under
-- each one. <CR> applies the highlighted choice, 1-9 pick directly, s skips,
-- q or <Esc> stops.
function M.review(rule)
  local bufnr = vim.api.nvim_get_current_buf()
  local client = harper(bufnr)
  if not client then
    vim.notify("harper_ls is not attached to this buffer", vim.log.levels.WARN)
    return
  end
  local ns = vim.lsp.diagnostic.get_namespace(client.id)
  local ctx =
    { bufnr = bufnr, client = client, uri = vim.uri_from_bufnr(bufnr) }
  local show

  local function done()
    vim.notify("Harper: no more problems" .. (rule and (" for " .. rule) or ""))
  end

  -- After a change, Harper's diagnostics are stale until it rechecks the
  -- buffer, so wait for the one just handled to disappear before moving on.
  local function advance(d, changed)
    local function go()
      local nxt, left = after(sorted(bufnr, ns, rule), d.lnum, d.col)
      if nxt then
        show(nxt, left)
      else
        done()
      end
    end
    if not changed then
      return go()
    end
    local timer, waited, finished = assert(vim.uv.new_timer()), 0, false
    timer:start(
      50,
      50,
      vim.schedule_wrap(function()
        if finished then
          return
        end
        waited = waited + 50
        local still = vim
          .iter(vim.diagnostic.get(bufnr, { namespace = ns }))
          :any(function(x)
            return x.lnum == d.lnum
              and x.col == d.col
              and x.message == d.message
          end)
        if not still or waited >= 2000 then
          finished = true
          timer:stop()
          timer:close()
          go()
        end
      end)
    )
  end

  show = function(d, left)
    -- Another buffer may have taken the window while Harper was rechecking.
    if vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end
    vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col })
    vim.cmd("normal! zz")
    local lsp = d.user_data.lsp
    client:request("textDocument/codeAction", {
      textDocument = { uri = ctx.uri },
      range = lsp.range,
      context = { diagnostics = { lsp } },
    }, function(err, result)
      vim.schedule(function()
        if err then
          vim.notify(
            "Harper: " .. tostring(err.message or err),
            vim.log.levels.ERROR
          )
          return
        end
        local items = {}
        for i, a in ipairs(result or {}) do
          items[#items + 1] =
            { key = i <= 9 and tostring(i) or " ", title = a.title, action = a }
        end
        items[#items + 1] = { key = "s", title = "Skip" }
        items[#items + 1] = { key = "q", title = "Stop", stop = true }
        pick(ctx, d, left, items, function(item)
          if not item or item.stop then
            return
          end
          local a = item.action
          if not a then
            return advance(d, false)
          end
          if a.edit then
            vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding)
          end
          local cmd = type(a.command) == "table" and a.command
            or (type(a.command) == "string" and a)
          if cmd then
            client:exec_cmd(cmd, { bufnr = bufnr })
          end
          advance(d, true)
        end)
      end)
    end, bufnr)
  end

  local first, left = at_or_after_cursor(sorted(bufnr, ns, rule))
  if first then
    show(first, left)
  else
    done()
  end
end

-- Rule names among the current buffer's Harper problems, for completing
-- :HarperReview.
function M.rules(lead)
  local client = harper(0)
  if not client then
    return {}
  end
  local ns = vim.lsp.diagnostic.get_namespace(client.id)
  local seen = {}
  for _, d in ipairs(vim.diagnostic.get(0, { namespace = ns })) do
    if type(d.code) == "string" and vim.startswith(d.code, lead) then
      seen[d.code] = true
    end
  end
  local names = vim.tbl_keys(seen)
  table.sort(names)
  return names
end

return M
