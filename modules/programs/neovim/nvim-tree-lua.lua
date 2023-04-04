-- try to fix flicker

local api = require("nvim-tree.api")

-- setup

function shy_toggle()
  return api.tree.toggle({ focus = false })
end

function shy_open() 
  api.node.open.edit()
  api.tree.toggle()
end

function shy_inplace_open()
  api.node.open.edit()
  api.tree.toggle()
  vim.cmd('BufferPrevious')
  if not pcall(function () vim.cmd('bd') end) 
    then print('Opened in new buffer due to modified self.') 
  end
end

-- global keybinds
--
vim.g.mapleader = ' '

local set = vim.keymap.set
local opts = { noremap = true, silent = true, nowait = true }
set('n', 'Q', api.tree.toggle,  opts)
set('n', 'J', '<Cmd>BufferPrevious<CR>', opts)
set('n', 'K', '<Cmd>BufferNext<CR>', opts)
-- set('n', 'Q', api.tree.focus, opts)

-- local keybinds
local M = {}
function M.on_attach(bufnr)
local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

set('n', 'Q', api.tree.toggle,  opts)
set('n', 'o', shy_inplace_open, opts)
set('n', 'O', shy_open, opts)
-- set('n', 'Q', ':bprevious<CR>', opts)

set('n', 'h', api.tree.toggle_help, opts)
set('n', '?', api.tree.toggle_help, opts)



end

-- final setup

require("nvim-tree").setup({
  on_attach = M.on_attach,
})
