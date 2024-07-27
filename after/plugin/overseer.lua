local has_overseer, overseer = pcall(require, "overseer")
if not has_overseer then
	return
end

overseer.setup({
	-- strategy = {
	-- 	"toggleterm",
	-- },
})
