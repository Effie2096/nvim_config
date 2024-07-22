local has_headlines, headlines = pcall(require, "headlines")
if not has_headlines then
	return
end

local opts = {
	fat_headlines = false,
	headline_highlights = {
		"Heading1",
		"Heading2",
		"Heading3",
		"Heading4",
		"Heading5",
		"Heading6",
	},
	bullet_highlights = {
		"HeadingBullet",
	},
	bullets = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳" },
	-- bullets = { "", "◉", "○", "✸" },
}

headlines.setup({
	markdown = opts,
})
