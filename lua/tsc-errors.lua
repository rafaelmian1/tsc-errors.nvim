--- A Neovim plugin to collect TypeScript compiler errors and populate the quickfix list.
--- @module tsc-errors
--- @copyright 2025
--- @license MIT

--- The module table
--- @class TSCErrors
local M = {}

--- Default configuration options
--- @type table
local default_opts = {
	key = "<leader>tsce",
	qf_preview = function()
		vim.cmd("copen")
	end,
	tsc_cmd = "npx tsc --noEmit",
	qf_title = "TSC compile errors",
}

--- Run TypeScript compiler and parse the output into a quickfix list format
--- @return table Array of quickfix items
local function tsc_errors()
	-- Run TypeScript compiler and capture output
	local output = vim.fn.systemlist(M.options.tsc_cmd)
	local qf_list = {}

	-- Process each line of the output
	for _, line in ipairs(output) do
		-- Skip summary lines that start with "Found"
		if line:match("^Found") then
			goto continue
		end

		-- Extract file, line, column, and error message using pattern matching
		-- Format: file(row,col): error TSxxxx: message
		local file, row, col, message = line:match("^(.-)%((%d+),(%d+)%)%s*:%s*error TS%d+:%s*(.*)$")

		-- If we successfully parsed the line, add it to the quickfix list
		if file and row and col and message then
			message = message:gsub("^%s+", "") -- Remove leading whitespace from message
			table.insert(qf_list, {
				filename = file,
				lnum = tonumber(row),
				col = tonumber(col),
				text = message,
			})
		end

		::continue::
	end

	return qf_list
end

--- Update the quickfix list with TypeScript errors
--- @param qf_items table Array of quickfix items
--- @return number Number of errors
local function update_quickfix(qf_items)
	vim.fn.setqflist({}, "r", {
		title = M.options.qf_title,
		items = qf_items,
	})

	return #qf_items
end

--- Main function to handle TypeScript errors - runs compiler, updates quickfix, and handles display
function M.tsc_quickfix()
	-- Get the error list from TypeScript compiler
	local qf_items = tsc_errors()

	-- Update the quickfix list with the errors
	local error_count = update_quickfix(qf_items)

	-- Handle the UI based on whether errors were found
	if error_count > 0 then
		M.options.qf_preview()
		vim.notify(string.format("Found %d TypeScript error(s)", error_count), vim.log.levels.WARN)
	else
		vim.notify("No TypeScript errors found", vim.log.levels.INFO)
	end
end

--- Function type for previewing the quickfix list
--- @alias QfPreviewFn fun()

--- Configuration options for the plugin
--- @class SetupOptions
--- @field qf_preview? QfPreviewFn Custom function to open the quickfix list
--- @field key? string Custom keymap for triggering error checking
--- @field tsc_cmd? string Command to run TypeScript compiler
--- @field qf_title? string Title for the quickfix list

--- Set up the plugin with user configuration
--- @param opts? SetupOptions User configuration options (optional)
function M.setup(opts)
	-- Merge user options with defaults
	M.options = vim.tbl_deep_extend("force", default_opts, opts or {})

	-- Set up the keymap
	vim.keymap.set("n", M.options.key, function()
		M.tsc_quickfix()
	end, {
		noremap = true,
		silent = true,
		desc = "TypeScript Errors Quickfix List",
	})

	-- Return the module for chaining
	return M
end

return M
