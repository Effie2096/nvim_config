local has_notify, notify = pcall(require, "notify")
if not has_notify then
	return
end

notify.setup({
	background_colour = "#000000",
})
