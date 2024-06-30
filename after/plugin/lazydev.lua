local has_lazydev, lazydev = pcall(require, "lazydev")
if not has_lazydev then
	return
end

lazydev.setup()
