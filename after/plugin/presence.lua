local has_presence, presence = pcall(require, "presence")
if not has_presence then
	return
end

presence.setup({
	auto_update = true,
	neovim_image_text = "Ye, I'm a boomer T~T",
	blacklist = { "BrainFart" },
})
