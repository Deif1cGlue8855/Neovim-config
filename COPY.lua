vim.opt.shadafile = "NONE"
vim.opt.splitright = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.g.mapleader = " "
--For the folding plugin 
vim.o.foldcolumn = "1"       -- show foldcolumn
vim.o.foldenable = true      -- enable folding
vim.o.foldmethod = 'expr'    -- <-- this is CRITICAL
vim.o.foldexpr = 'v:lua.require("ufo").get_fold_expr()' -- <-- UFO uses this
-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    command = "setlocal formatoptions+=t"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    command = "setlocal wrap linebreak nolist"
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.cmd("lcd %:p:h")
    end
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "TelescopePrompt" then
            vim.wo.number = true
            vim.wo.relativenumber = true
        end
    end
})

-- Toggle diagnostics
local diagnostics_enabled = true
vim.api.nvim_set_keymap('n', 'zz', ":lua ToggleDiagnostics()<CR>", { noremap = true, silent = true })
function ToggleDiagnostics()
    if diagnostics_enabled then
        vim.diagnostic.hide()
    else
        vim.diagnostic.show()
    end
    diagnostics_enabled = not diagnostics_enabled
end

-- Keymaps
vim.api.nvim_set_keymap("n", ".", "<Cmd>tabnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "fb", ":Telescope file_browser<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Tab>', '    ', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'a', 'i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 's', 'a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Space>", ":nohlsearch<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-e>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-y>", { noremap = true, silent = true })
-- Bind <leader>mp to toggle Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>r", "<cmd>Telescope lsp_references<CR>", { desc = "LSP References" })

vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprev<CR>', { noremap = true, silent = true })
-- Toggle NvimTree with <leader>e
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


vim.keymap.set("n", "<leader>bb", function()
  require("telescope.builtin").buffers()
end, { desc = "List Buffers" })

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end)

--Smear cursor settings
vim.api.nvim_set_hl(0, "SmearCursorTrail", {
  fg = "#ff00ff",
  bg = "#ff00ff",
  bold = true,
  reverse = true,
})

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
-- SMALLER IMPORTS
{ "rebelot/kanagawa.nvim",config = function() vim.cmd.colorscheme("kanagawa") end },   
--{ "olimorris/onedarkpro.nvim", config = function() vim.cmd.colorscheme("onedark") end },
{ "glepnir/dashboard-nvim", event = "VimEnter" },
{ "neovim/nvim-lspconfig" },
{ "hrsh7th/nvim-cmp" , event = "InsertEnter"},
{ "hrsh7th/cmp-buffer" },
{ "hrsh7th/cmp-path" },
{ "hrsh7th/cmp-cmdline" },
{ "L3MON4D3/LuaSnip", event = "InsertEnter" },
{ "saadparwaiz1/cmp_luasnip" },
{ "vim-denops/denops.vim", build = ":call denops#install()" },
{ "RRethy/vim-illuminate", event = "CursorHold"},
{ "rafamadriz/friendly-snippets" },
--MASON
{
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
},
--MARKSMAN
{
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({ ensure_installed = { "marksman" } })
      require("lspconfig").marksman.setup({})
    end,
},
-- TREE SITTER
{
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "cpp", "python" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
},
-- LUALINE
{
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = 'auto',
          section_separators = { left = "", right = "" },
          component_separators = {left = "\\", right = "/"} ,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {"diagnostics"},
          lualine_c = { { "filename", path = 2 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        tabline = {
            lualine_a = {'buffers'},
            lualine_z = {'tabs'},
        },
     })
     end,
},
-- TELESCOPE
{
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({ defaults = { preview = { filetype_detect = false } } })
    end,
},
--TELESCOPE FILE BROWSER
{ 
    "nvim-telescope/telescope-file-browser.nvim" 
},
-- NO IDEAD
{
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
    end,
},
-- MARKDOWN PREVIEW COMMANDS
{
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" }, -- this means it only loads in markdown files
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_browser = "" -- system default
  end,
},

-- SMEAR CURSOR
{
    "sphamba/smear-cursor.nvim",
      event = "VeryLazy",
      config = function()
        require("smear_cursor").setup({
          enabled = true,        -- enable by default
          highlight = "SmearCursorTrail",  -- the highlight group used for the smear
          timeout = 1500,         -- how long the smear lasts (ms)
        })

        -- Optional keymap to toggle it
        vim.keymap.set("n", "<leader>cs", function()
          require("smear_cursor").toggle()
        end, { desc = "Toggle Smear Cursor" })
      end,   
  },

    
-- LINE OPERATION HIGHLIGHTING
{
    "svampkorg/moody.nvim",
    event = { "ModeChanged", "BufWinEnter", "WinEnter" , "VeryLazy"},
    dependencies = {
        "catppuccin/nvim",
        "kevinhwang91/nvim-ufo"
    },
    opts = {
        blends = {
            normal = 0.2,
            insert = 0.2,
            visual = 0.25,
            command = 0.2,
            operator = 0.2,
            replace = 0.2,
            select = 0.2,
            terminal = 0.2,
            terminal_n = 0.2,
        },
        colors = {
            normal = "#00BFFF",
            insert = "#70CF67",
            visual = "#AD6FF7",
            command = "#EB788B",
            operator = "#FF8F40",
            replace = "#E66767",
            select = "#AD6FF7",
            terminal = "#4CD4BD",
            terminal_n = "#00BBCC",
        },
        disabled_filetypes = { "TelescopePrompt" },
        disabled_buftypes = { },
        bold_nr = true,
        recording = {
            enabled = true,
            icon = "󰯙",
            pre_registry_text = "[",
            post_registry_text = "]",
            right_padding = 2,
        },
        extend_to_linenr = true,
        extend_to_linenr_visual = false,
        reduce_cursorline = false,
        fold_options = {
            enabled = false,
            start_color = "#C1C1C1",
            end_color = "#2F2F2F",
        },
    },
  },
-- HIDING AND UNHIDING BRACKETS
{
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async", -- Required dependency
    },
    config = function()
      vim.o.foldcolumn = "1"       -- '0' is hidden, '1' shows fold column
      vim.o.foldlevel = 99         -- Ensure folds are open by default
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "treesitter", "indent" }
        end,
      })
    end,
},   
--LINES SHOWING INDENTATIONS
{
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
},
-----------------------------------------------------------------------------------    
})

require("luasnip.loaders.from_vscode").lazy_load()

require("mason-lspconfig").setup({
  ensure_installed = { "pyright" }
})
-- LSP Setup
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
})

lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    -- Bind K to show hover
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

    -- Customize the hover window appearance
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",         -- Optional: to make the popup look nicer
      max_height = 20,            -- Adjust the height of the hover window
      max_width = 200,             -- Adjust the width of the hover window
    })
  end,
})

-- nvim-cmp Setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

vim.o.showtabline = 2
--Telescope config settings
require('telescope').setup{
  defaults = {
    prompt_prefix = ">",
    selection_caret = "",
    entry_prefix = "  ",
    layout_config = {
      prompt_position = "bottom",
      width = 0.9,
      height = 0.85,
      preview_cutoff = 120,
    },
    layout_strategy = "horizontal", -- or "vertical", "center", "cursor"
    --borderchars = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
    winblend = 25, -- transparency (0 = opaque, 100 = fully transparent)
    results_title = false,
    preview_title = false,
  }
}
require("ibl").setup()
