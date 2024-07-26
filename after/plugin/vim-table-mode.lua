vim.cmd([[
let g:table_mode_corner='|'
]])

--[[ local desc = require("faith.keymap").desc
local opts = { noremap = true, silent = true }
vim.keymap.set(
	"n",
	"<leader>tmcl",
	"<Plug>(table-mode-insert-column-after)",
	desc(opts, "[t]able [m]ode [c]olumn after")
)
vim.keymap.set(
	"n",
	"<leader>tmch",
	"<Plug>(table-mode-insert-column-before)",
	desc(opts, "[t]able [m]ode [c]olumn before")
)
vim.keymap.set("n", "<leader>tmr", "<Plug>(table-mode-realign)", desc(opts, "[t]able [m]ode [r]ealign"))
vim.keymap.set("n", "<leader>tmfa", "<Plug>(table-mode-add-formula)", desc(opts, "[t]able [m]ode [f]ormula [a]dd"))
vim.keymap.set("n", "<leader>tmfe", "<Plug>(table-mode-eval-formula)", desc(opts, "[t]able [m]ode [f]ormula [e]val")) ]]
