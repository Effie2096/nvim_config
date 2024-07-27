local has_leap, leap = pcall(require, "leap")
if not has_leap then
	return
end

leap.create_default_mappings()

-- Define equivalence classes for brackets and quotes, in addition to
-- -- the default whitespace group.
require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
