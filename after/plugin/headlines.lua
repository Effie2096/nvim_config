local has_headlines, headlines = pcall(require, "headlines")
if not has_headlines then
	return
end

local opts = {
	fat_headlines = false,
	bullets = { "", "◉", "○", "✸" },
}

headlines.setup({
	markdown = opts,
})
