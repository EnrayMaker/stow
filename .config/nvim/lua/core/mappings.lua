vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Сохранить файл" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Закрыть окно" })

-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree left focus<CR>")
-- terminal
vim.keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	local choices = {
		{ text = "🔍  Find Files", value = "find_files" },
		{ text = "📝  Live Grep", value = "live_grep" },
		{ text = "📂  Buffers", value = "buffers" },
		{ text = "❓  Help Tags", value = "help_tags" },
		{ text = "󰊢  Git Status", value = "git_status" },
		{ text = "  Git Commits", value = "git_commits" },
		{ text = "  Git Branches", value = "git_branches" },
		{ text = "󰆧  LSP Symbols", value = "lsp_document_symbols" },
	}

	local function run_selected(selection)
		local builtin = require("telescope.builtin")
		local func = builtin[selection.value]
		if func then
			func()
		end
	end

	pickers
		.new({}, {
			prompt_title = "Telescope Menu",
			finder = finders.new_table({
				results = choices,
				entry_maker = function(entry)
					return {
						value = entry.value,
						display = entry.text,
						ordinal = entry.text,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					run_selected(selection)
				end)
				return true
			end,
		})
		:find()
end, { desc = "Telescope menu" })
--lsp
vim.keymap.set("n", "gr", builtin.lsp_references, { noremap = true, silent = true })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { noremap = true, silent = true })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
-- leap
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward to" })
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward to" })
vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", { desc = "Leap from window" })
vim.keymap.set("n", "T", "<Plug>(leap-backward-till)", { desc = "leap-backward-till" })
vim.keymap.set("n", "t", "<Plug>(leap-forward-till)", { desc = "leap-forward-till" })
--conform
local conform = require("conform")
vim.keymap.set({ "n" }, "<leader>fm", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format file (Conform)" })
vim.keymap.set({ "x" }, "<leader>fm", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format selection (Conform)" })

-- Gitsigns Mappings
local gs = require("gitsigns")
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		gs.next_hunk()
	end)
	return "<Ignore>"
end, { expr = true, desc = "Next Hunk" })

vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		gs.prev_hunk()
	end)
	return "<Ignore>"
end, { expr = true, desc = "Prev Hunk" })

-- git
vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk (Pop-up)" })
vim.keymap.set("n", "<leader>gb", function()
	gs.blame_line({ full = true })
end, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

-- Debug
vim.keymap.set("n", "\\c", function()
	require("dap").continue()
end, { desc = "Continue/Start Debugging" })
vim.keymap.set("n", "\\o", function()
	require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "\\i", function()
	require("dap").step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "\\u", function()
	require("dap").step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "\\b", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "\\r", function()
	require("dap").repl.open()
end, { desc = "Open REPL" })
vim.keymap.set("n", "\\x", function()
	require("dap").terminate()
end, { desc = "Terminate Debugging" })
vim.keymap.set("n", "\\h", function()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })
vim.keymap.set({ "n", "v" }, "\\e", function()
	require("dapui").eval()
end, { desc = "Eval Expression" })

--python
vim.keymap.set("n", "<leader>pv", "<cmd>VenvSelect<cr>", { desc = "Select Virtual Env" })
vim.keymap.set("n", "<leader>pm", "<cmd>lua require('dap-python').test_method()<cr>", { desc = "Test Method" })
vim.keymap.set("n", "<leader>pc", "<cmd>lua require('dap-python').test_class()<cr>", { desc = "Test Class" })

-- Toggle LSP diagnostics
vim.keymap.set("n", "<leader>ll", function()
	local current_config = vim.diagnostic.config()
	local new_signs_state = not current_config.signs

	vim.diagnostic.config({
		signs = new_signs_state,
	})

	local state = new_signs_state and "ВКЛ" or "ВЫКЛ"
	vim.notify("LSP значки: " .. state, vim.log.levels.INFO)
end, { desc = "Toggle LSP diagnostic signs" })

-- moving
vim.keymap.set("n", "<S-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<S-j>", "<C-w>j", { desc = "Go to down window" })
vim.keymap.set("n", "<S-k>", "<C-w>k", { desc = "Go to up window" })
vim.keymap.set("n", "<S-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
vim.keymap.set("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
vim.keymap.set("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase height" })
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit [V]ertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit [H]orizontal" })
vim.keymap.set("n", "<leader>sc", "<C-w>c", { desc = "[S]plit [C]lose window" })

vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "[T]ab [N]ew" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "[T]ab [C]lose" })
vim.keymap.set("n", "<leader>t]", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>t[", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- lua/core/mappings.lua
vim.keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "[C]Make [G]enerate" })
vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "[C]Make [B]uild" })
vim.keymap.set("n", "<leader>cr", "<cmd>CMakeRun<CR>", { desc = "[C]Make [R]un" })
vim.keymap.set("n", "<leader>cc", "<cmd>CMakeClean<CR>", { desc = "[C]Make [C]lean" })
vim.keymap.set("n", "<leader>cs", "<cmd>CMakeStop<CR>", { desc = "[C]Make [S]top running program" })
vim.keymap.set("n", "<leader>csq", "<cmd>CMakeClose<CR>", { desc = "[C]Make [S]top and [Q]uit runner" })

--c++
vim.keymap.set("n", "<leader>cm", function()
	local actions = {
		{
			"🚀  Generate & Build",
			function()
				vim.cmd("CMakeGenerate")
				-- Ждем немного перед сборкой
				vim.defer_fn(function()
					vim.cmd("CMakeBuild")
				end, 500)
			end,
		},
		{
			"🔨  Build",
			function()
				vim.cmd("CMakeBuild")
			end,
		},
		{
			"▶️   Run",
			function()
				vim.cmd("CMakeRun")
			end,
		},
		{
			"⏹️   Stop",
			function()
				vim.cmd("CMakeStopRunner")
			end,
		},
		{
			"🧹  Clean",
			function()
				vim.cmd("CMakeClean")
			end,
		},
		{
			"⚙️   Select Build Type",
			function()
				vim.cmd("CMakeSelectBuildType")
			end,
		},
		{
			"🎯  Select Target",
			function()
				vim.cmd("CMakeSelectTarget")
			end,
		},
		{
			"📋  Configure Arguments",
			function()
				vim.cmd("CMakeConfigure")
			end,
		},
		{
			"🗑️   Clean & Rebuild",
			function()
				vim.cmd("CMakeClean")
				vim.defer_fn(function()
					vim.cmd("CMakeBuild")
				end, 300)
			end,
		},
		{
			"🔍  Select Launch Target",
			function()
				vim.cmd("CMakeSelectLaunchTarget")
			end,
		},
	}

	vim.ui.select(actions, {
		prompt = "CMake Actions:",
		format_item = function(item)
			return item[1]
		end,
	}, function(choice)
		if choice then
			-- Вызываем функцию, а не строку команды
			choice[2]()
		end
	end)
end, { desc = "[C]Make [M]enu" })
