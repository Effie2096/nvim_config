vim.filetype.add({
	extension = {
		kbd = "kanata",
		env = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
	},
	pattern = {
		["^%.?env%.?[a-z]$"] = "dotenv",
	},
})
