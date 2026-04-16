vim.filetype.add({
	extension = {
		kbd = "kanata",
		env = "dotenv",
		sc = "supercollider",
		scd = "supercollider",
	},
	filename = {
		[".env"] = "dotenv",
	},
	pattern = {
		["^%.?env%.?[a-z]$"] = "dotenv",
	},
})
