local has_dap_python, dap_python = pcall(require, "dap-python")
if not has_dap_python then
	return
end

local debugpy = require("mason-registry").get_package("debugpy")
local extension_path = debugpy:get_install_path()
local venv_path = extension_path .. "/venv/"
local python_path = venv_path .. "bin/python"
if vim.fn.has("win32") == 1 then
	python_path = venv_path .. "Scripts\\python.exe"
end

dap_python.setup(python_path)

dap_python.test_runner = "pytest"
dap_python.resolve_python = function()
	if vim.fn.has("win32") == 1 then
		return vim.fn.glob(
			os.getenv("HOME") .. "\\.virtualenvs\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "*" .. "\\Scripts"
		) .. "\\python"
	end
	return vim.fn.glob(os.getenv("XDG_CACHE_HOME") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "*" .. "/bin")
		.. "/python"
end
