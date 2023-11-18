local art = {
  [[                                                   ]],
  [[                                              ___  ]],
  [[                                           ,o88888 ]],
  [[                                        ,o8888888' ]],
  [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
  [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
  [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
  [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
  [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
  [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
  [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
  [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
  [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
  [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
  [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
  [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
  [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
  [[     ...:.'.:.::::"'    . . . . .'                 ]],
  [[    .. . ....:."' `   .  . . ''                    ]],
  [[  . . . ...."'                                     ]],
  [[  .. . ."'                                         ]],
  [[ .                                                 ]],
  [[                                                   ]],
}

local config = function()
  local dash = require("alpha.themes.dashboard")
  dash.section.header.val = art
  dash.section.buttons.val = {
    dash.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dash.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
    dash.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dash.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
  }
  for _, button in ipairs(dash.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
  end
  dash.section.footer.opts.hl = "Constant"
  dash.section.header.opts.hl = "AlphaHeader"
  dash.section.buttons.opts.hl = "AlphaButtons"
  dash.opts.layout[1].val = 0
  require("alpha").setup(dash.opts)
end

return {
  name = "goolord/alpha-nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = config,
}
