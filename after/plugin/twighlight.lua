local status_ok, twighlight = pcall(require, 'twighlight')
if not status_ok then
	return
end

twighlight.setup({
	context = 20
})
