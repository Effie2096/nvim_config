local util = require 'lspconfig.util'
return {
	cmd = { 'lemminx' },
	filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
	root_dir = util.find_git_ancestor,
	single_file_support = true,
}
