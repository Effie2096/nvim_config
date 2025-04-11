local has_sunglasses, sunglasses = pcall(require, "sunglasses")
if not has_sunglasses then
	return
end

sunglasses.setup({
	filter_type = "SHADE",
	filter_percent = 0.20,
})
