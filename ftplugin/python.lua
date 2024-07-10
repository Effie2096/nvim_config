local has_dap_python, dap_python = pcall(require, "dap-python")
if not has_dap_python then
	return
end

local debugpy = require("mason-registry").get_package("debugpy")
local extension_path = debugpy:get_install_path()
local venv_path = extension_path .. "/venv/"
local python_path = venv_path .. "bin/python"

dap_python.setup(python_path)

dap_python.resolve_python = function()
	return os.getenv("XDG_CACHE_HOME") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "/bin/python"
end
