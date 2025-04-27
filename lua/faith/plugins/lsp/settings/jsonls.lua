local schemas = {}
local status_ok, schemastore = pcall(require, "schemastore")
if status_ok then
	schemas = schemastore.json.schemas()
end

return {
	init_options = {
		provideFormatter = false,
	},
	settings = {
		json = {
			schemas = schemas,
			validate = { enable = true },
		},
	},
	setup = {
		commands = {
			-- Format = {
			--   function()
			--     vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
			--   end,
			-- },
		},
	},
}
