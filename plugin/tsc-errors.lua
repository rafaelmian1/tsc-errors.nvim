vim.api.nvim_create_user_command("TSCErrors", function()
	require("tsc-errors").tsc_quickfix()
end, {})
