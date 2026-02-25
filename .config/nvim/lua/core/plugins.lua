local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

--vim.g.maplocalleader = " "

require("lazy").setup({
	spec = {
		{ "ggandor/leap.nvim", opts = {} }, -- Конфигурация Leap
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			build = ":TSUpdate",
			opts = {
				ensure_installed = { "lua", "python", "cpp", "yaml", "bash", "cmake" },
				sync_install = false,
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			},
		},
		{
			"numToStr/Comment.nvim",
			opts = {},
			lazy = false,
		},
		{
			"stevearc/oil.nvim",
			opts = {},
			-- В зависимости от настроек, можно вызывать по <leader>-e
			keys = {
				{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
			},
		},
		-- NeoTree
		{
			"nvim-neo-tree/neo-tree.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
			opts = {
				window = {
					position = "left",
					width = 30,
				},
				filesystem = {
					hijack_netrw = true,
					use_libuv_file_watch = true,
				},
			},
		},

		-- nvim-cmp
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
			},
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "buffer" },
						{ name = "path" },
					}),
					mapping = cmp.mapping.preset.insert({
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					}),
				})
			end,
		},

		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("telescope").setup({
					defaults = {
						preview = {
							treesitter = false, -- отключить treesitter для preview
						},
					},
				})
			end,
		},

		-- conform.nvim
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					yaml = { "yamlfmt" },
					cpp = { "clang_format" },
					terraform = { "terraform_fmt" },
				},
				format_on_save = true,
			},
		},

		-- gitsigns.nvim
		{
			"lewis6991/gitsigns.nvim",
			opts = {},
		},
		{
			"NeogitOrg/neogit",
			lazy = true,
			dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
			cmd = "Neogit",
			keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" } },
		},
		-- Темы
		{ "eldritch-theme/eldritch.nvim", lazy = false, priority = 1000, opts = {} },
		-- lsp
		{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v3.x",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
				"williamboman/mason.nvim",
			},
			config = function()
				local lsp_zero = require("lsp-zero")

				lsp_zero.on_attach(function(client, bufnr)
					lsp_zero.default_keymaps({ buffer = bufnr })
				end)
				require("mason").setup()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"pyright",
						"clangd",
						"yamlls",
						"ansiblels",
						"dockerls",
						"helm_ls",
					},
					handlers = {
						lsp_zero.default_setup,
					},
				})
				vim.diagnostic.config({
					virtual_text = true,
					update_in_insert = false,
					underline = true,
					severity_sort = true,
				})
			end,
		},
		-- python
		{
			"mfussenegger/nvim-dap",
			lazy = true,
			config = function()
				local dap = require("dap")
				-- Базовые настройки
				vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
				vim.fn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })
			end,
		},

		-- Python DAP
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require("dap-python").setup("python3")
				require("dap-python").test_runner = "pytest"
			end,
		},
		-- DAP UI (опционально, но удобно)
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap" },
			lazy = true,
			config = function()
				require("dapui").setup()
				local dap = require("dap")
				local dapui = require("dapui")
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open()
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close()
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close()
				end
			end,
		},

		-- Выбор виртуального окружения Python
		{
			"linux-cultist/venv-selector.nvim",
			ft = "python",
			dependencies = {
				"neovim/nvim-lspconfig",
				"nvim-telescope/telescope.nvim",
				"mfussenegger/nvim-dap-python",
			},
			opts = {
				name = { "venv", ".venv", "env", ".env" }, -- Имена папок с venv
				auto_refresh = true,
			},
			keys = {
				{ "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Select Virtual Env" },
			},
			config = function(_, opts)
				require("venv-selector").setup(opts)
			end,
		},
		{
			"folke/trouble.nvim",
			opts = {},
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
		{ "mrjosh/helm-ls", ft = "helm" },
		-- kube-utils
		{
			"h4ckm1n-dev/kube-utils-nvim",
			dependencies = { "nvim-telescope/telescope.nvim" },
			lazy = true,
		},
		{
			"Civitasv/cmake-tools.nvim",
			ft = { "cpp", "c", "cmake" },
			lazy = false,
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("cmake-tools").setup({
					cmake_command = "cmake",
					cmake_build_directory = "build",
					cmake_build_directory_prefix = "build/",
					cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
					cmake_build_options = {},
					cmake_console_size = 10,
					cmake_show_console = "always",
					cmake_dap_configuration = {
						name = "cpp",
						type = "codelldb",
						request = "launch",
						stopOnEntry = false,
						runInTerminal = false,
					},
					cmake_variants_message = {
						short = { show = true },
						long = { show = true, max_length = 40 },
					},
				})
			end,
		},
	},
	checker = { enabled = true },
})
