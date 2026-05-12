return {
  -- File tree (replaces NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        filters = { dotfiles = false },
        git = { enable = false },
        diagnostics = { enable = false },
        renderer = { icons = { show = { git = false, folder = false, file = false, folder_arrow = true } } },
      })
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
      vim.keymap.set("n", ",n", ":NvimTreeFindFile<CR>")
      vim.keymap.set("n", ",m", ":NvimTreeToggle<CR>")
    end,
  },

  -- Statusline (replaces vim-airline)
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "filename", path = 1 } },
          lualine_c = {},
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        tabline = {
          lualine_a = { "buffers" },
          lualine_z = { "tabs" },
        },
      })
    end,
  },

  -- Fuzzy finder (replaces fzf.vim)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          layout_strategy = "bottom_pane",
          layout_config = { height = 0.5, prompt_position = "bottom" },
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
            },
          },
        },
      })
      vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>")
      vim.keymap.set("n", "<C-l>", "<cmd>Telescope buffers<CR>")
      vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<CR>")
      vim.api.nvim_create_user_command("Rg", function(opts)
        require("telescope.builtin").grep_string({ search = opts.args })
      end, { nargs = "*" })
    end,
  },

  -- Git integration
  { "tpope/vim-fugitive" },

  -- Syntax highlighting via treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.g.ts_auto_install = true
    end,
  },
}
