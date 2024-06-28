local has_image, image = pcall(require, "image")
if not has_image then
	return
end

image.setup({
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp" }, -- render image files as images when opened
	max_height = 15,
	window_overlap_clear_enabled = true,
	integrations = {
		markdown = {
			only_render_image_at_cursor = true,
			resolve_image_path = function(document_path, image_path, fallback)
				local cwd = vim.fn.getcwd()
				if vim.fn.filereadable(cwd .. "/" .. image_path) then
					return cwd .. "/" .. image_path
				end
				return fallback(document_path, image_path)
			end,
		},
	},
})
