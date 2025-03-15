local opts = { noremap = true, silent = true }

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

-- Search
keymap("n", "<leader><Space>", ":nohl<cr>", opts)

-- Tree View
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Nagivate tabs
keymap("n", "<S-Right>", ":tabnext<CR>", opts)
keymap("n", "<S-Left>", ":tabprevious<CR>", opts)

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

-- Quick Fix
keymap("n", "<leader>co", "<cmd>copen<cr>", opts) -- Open quick fix
keymap("n", "<leader>cc", "<cmd>cclose<cr>", opts) -- Close quick fix

-- Only load the following keymaps if not in vscode.
if not vim.g.vscode then
  -- Better window navigation
  keymap("n", "<C-h>", "<C-w>h", opts)
  keymap("n", "<C-j>", "<C-w>j", opts)
  keymap("n", "<C-k>", "<C-w>k", opts)
  keymap("n", "<C-l>", "<C-w>l", opts)

  -- Resize with arrows
  keymap("n", "<C-Up>", ":resize -2<CR>", opts)
  keymap("n", "<C-Down>", ":resize +2<CR>", opts)
  keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
  keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

  -- Formatting
  keymap("n", "<leader>tf", "<cmd>Format<cr>", opts) -- Tools Format

  -- Buffers
  keymap("n", "<S-q>", "<cmd>Bdelete!<cr>", opts) -- Close buffer without close window
  keymap("n", "<A-Q>", "<cmd>qa<cr>", opts) -- Close buffer without close window
else
-- Better window navigation
  keymap("n", "<C-A-h>", "<C-w>h", opts)
  keymap("n", "<C-A-j>", "<C-w>j", opts)
  keymap("n", "<C-A-k>", "<C-w>k", opts)
  keymap("n", "<C-A-l>", "<C-w>l", opts)

  -- Resize with arrows
  keymap("n", "<C-A-Up>", ":resize -2<CR>", opts)
  keymap("n", "<C-A-Down>", ":resize +2<CR>", opts)
  keymap("n", "<C-A-Left>", ":vertical resize -2<CR>", opts)
  keymap("n", "<C-A-Right>", ":vertical resize +2<CR>", opts)
end
