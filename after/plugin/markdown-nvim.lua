local has_render_markdown, render_markdown = pcall(require, "render-markdown")
if not has_render_markdown then
	return
end

render_markdown.setup({
	render_modes = { "n", "i", "c" },
	heading = {
		-- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
		icons = { " " },
	},
	bullet = {
		enabled = false,
	},
	checkbox = {
		enabled = false,
	},
	link = {
		enabled = false,
	},
	code = {
		left_pad = 1,
	},
	anti_conceal = {
		enabled = true,
	},
	win_options = {
		conceallevel = {
			rendered = 2,
		},
	},
	callout = {
		note = { raw = "[!NOTE]", rendered = "󰋽 Note ", highlight = "RenderMarkdownInfo" },
		tip = { raw = "[!TIP]", rendered = "󰌶 Tip ", highlight = "RenderMarkdownSuccess" },
		important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important ", highlight = "RenderMarkdownHint" },
		warning = { raw = "[!WARNING]", rendered = "󰀪 Warning ", highlight = "RenderMarkdownWarn" },
		caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution ", highlight = "RenderMarkdownError" },
		-- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
		abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract ", highlight = "RenderMarkdownInfo" },
		todo = { raw = "[!TODO]", rendered = "󰗡 Todo ", highlight = "RenderMarkdownInfo" },
		success = { raw = "[!SUCCESS]", rendered = "󰄬 Success ", highlight = "RenderMarkdownSuccess" },
		question = { raw = "[!QUESTION]", rendered = "󰘥 Question ", highlight = "RenderMarkdownWarn" },
		failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure ", highlight = "RenderMarkdownError" },
		danger = { raw = "[!DANGER]", rendered = "󱐌 Danger ", highlight = "RenderMarkdownError" },
		bug = { raw = "[!BUG]", rendered = "󰨰 Bug ", highlight = "RenderMarkdownError" },
		example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example ", highlight = "RenderMarkdownHint" },
		quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote ", highlight = "RenderMarkdownQuote" },
	},
})
