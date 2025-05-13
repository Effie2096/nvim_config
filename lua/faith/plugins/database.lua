return {
	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	{
		"cameron-wags/rainbow_csv.nvim",
		init = function()
			vim.g.disable_rainbow_statusline = 1
			vim.g.rbql_backend_language = "js"
		end,
		config = true,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},
}
