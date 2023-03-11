local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Respect soft wraps when moving around
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Search
keymap("n", "<leader><Space>", ":nohl<cr>", opts)

-- Tree View
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)
keymap("i", "<Down>", "<C-o>gj", opts)
keymap("i", "<Up>", "<C-o>gk", opts)

-- Visual --
-- Respect soft wraps when moving around
keymap("v", "j", "gj", opts)
keymap("v", "k", "gk", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope keymaps
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts) -- Find Files
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts) -- Find Grep
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts) -- Find Buffers
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts) -- Find Buffers
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts) -- Find Recent
keymap("n", "<leader>ft", "<cmd>Telescope treesitter<cr>", opts) -- Find Treesitter symbols

keymap("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>", opts) -- Find LSP references
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts)

-- Formatting
keymap("n", "<leader>tf", "<cmd>Format<cr>", opts) -- Tools Format

-- Quick Fix
keymap("n", "<leader>co", "<cmd>copen<cr>", opts) -- Open quick fix
keymap("n", "<leader>cc", "<cmd>cclose<cr>", opts) -- Close quick fix

-- Buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<cr>", opts) -- Close buffer without close window
keymap("n", "<A-Q>", "<cmd>qa<cr>", opts) -- Close buffer without close window

-- Trouble
keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", opts)

-- DAP
keymap("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", opts)
keymap("n", "<leader>dc", "<cmd>DapContinue<cr>", opts)
keymap("n", "<leader>di", "<cmd>DapStepInto<cr>", opts)
keymap("n", "<leader>do", "<cmd>DapStepOver<cr>", opts)
keymap("n", "<leader>dO", "<cmd>DapStepOut<cr>", opts)
keymap("n", "<leader>dr", "<cmd>DapToggleRepl<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>DapTerminate<cr>", opts)
keymap("n", "<A-k>", "<cmd>lua require'dapui'.eval()<cr>", opts)
keymap("v", "<A-k>", "<cmd>lua require'dapui'.eval()<cr>", opts)
