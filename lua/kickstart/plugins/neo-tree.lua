-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  window = {
    position = 'float',
    popup = {
      size = { height = '80%', width = '50%' },
      position = '50%',
    },
  },
  filesystem = {
    filtered_items = {
      visible = true, -- Set to true to show all hidden files
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        '.git',
      },
    },
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
