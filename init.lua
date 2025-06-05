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
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

--For the folding plugin 
vim.o.foldcolumn = "1"       -- show foldcolumn
vim.o.foldenable = true      -- enable folding
vim.o.foldmethod = 'expr'    -- <-- this is CRITICAL
--vim.o.foldexpr = 'v:lua.require("ufo").get_fold_expr()' -- <-- UFO uses this

--For python syntax highlighting
vim.g.python_highlight_class_vars = 1
vim.g.python_highlight_operators = 1
vim.g.python_highlight_self = 1

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    command = "setlocal formatoptions+=t"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    command = "setlocal wrap linebreak nolist"
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true        -- visually wrap long lines
    vim.opt_local.linebreak = true   -- wrap at word boundaries, not mid-word
  end,
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

--GIT COMMANDS
vim.api.nvim_set_keymap('n', '<leader>gs', ':lua saveRepo()<CR>', { noremap = true, silent = true })
function saveRepo()
    vim.ui.input({ prompt = 'Enter commit message: '}, function(message_commit)
        if message_commit ~= nil and message_commit ~= '' then
            vim.cmd('!git add . && git commit -m "'.. message_commit .. '" && git push') 
        end
    end)
end

vim.api.nvim_set_keymap('n', '<leader>gp', ':!git pull<CR>', { noremap = true, silent = true })
--GET CLONE OF REPO
vim.api.nvim_set_keymap('n', '<leader>gc', ':lua CloneRepo()<CR>', { noremap = true, silent = true })
function CloneRepo()
  vim.ui.input({ prompt = 'Enter repository name: ' }, function(repo_name)
    if repo_name ~= nil and repo_name ~= '' then
      local username = "Deif1cGlue8855"  -- your GitHub username
      local url = "git@github.com:" .. username .. "/" .. repo_name .. ".git"
      vim.cmd('!git clone ' .. url)
    end
  end)
end

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
--vim.api.nvim_set_keymap('n', 'a', 'i', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 's', 'a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Space>", ":nohlsearch<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-e>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-y>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fw', ":Telescope file_browser cwd=/mnt/Users/arlot<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- Bind <leader>mp to toggle Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>r", "<cmd>Telescope lsp_references<CR>", { desc = "LSP References" })

vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprev<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>bd', ':bdel<CR>', {noremap = true, silent = true})


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
--{ "rebelot/kanagawa.nvim",config = function() vim.cmd.colorscheme("kanagawa") end },   
--{ "olimorris/onedarkpro.nvim", config = function() vim.cmd.colorscheme("onedark") end },
{ "glepnir/dashboard-nvim", event = "VimEnter" },
{ "neovim/nvim-lspconfig",event = "BufReadPre" },
{ "hrsh7th/nvim-cmp" , event = "InsertEnter"},
{ "hrsh7th/cmp-buffer" },
{ "hrsh7th/cmp-path" },
{ "hrsh7th/cmp-cmdline" },
{'hrsh7th/cmp-nvim-lsp'},
{ "L3MON4D3/LuaSnip", event = "InsertEnter" },
{ "saadparwaiz1/cmp_luasnip" },
{ "vim-denops/denops.vim", build = ":call denops#install()" },
{ "RRethy/vim-illuminate", event = "CursorHold"},
{ "rafamadriz/friendly-snippets", event = "VeryLazy" },
{ "octol/vim-cpp-enhanced-highlight"},
{ "nvim-treesitter/nvim-treesitter-context" , event = "VeryLazy"},   
{ "p00f/clangd_extensions.nvim" , event = "VeryLazy"},
{ "ray-x/lsp_signature.nvim", event = "VeryLazy" },
{ "vim-python/python-syntax", ft = "python" , event = "VeryLazy"},
{ "tpope/vim-abolish" },
{'tpope/vim-fugitive'},
{'nvim-telescope/telescope-ghq.nvim'},

{
  "ellisonleao/gruvbox.nvim",
  priority = 1000,  -- Make sure it loads before other plugins
  config = function()
    require("gruvbox").setup({
      -- Optional settings:
        contrast = "soft", -- "soft", "medium", "hard"
        transparent_mode = true,
        italic = {
            strings = true,
            comments = true,
            operators = false,
            folds = true,
	    },
        dim_inactive = true,
    })
    vim.cmd.colorscheme("gruvbox")
  end
},
--MASON
{
    "williamboman/mason.nvim",
    event = "VeryLazy", 
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
    event = { "BufReadPost", "BufNewFile" },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = false })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "cpp", "python" },--       
        highlight = {
            enable = true,
            disable = { "cpp", "c" },
        },
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
          component_separators = {left = "╲", right = "╱"} ,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {'branch', 'diff',"diagnostics"},
          lualine_c = { { "filename", path = 2 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress"},
          lualine_z = { "location" },
        },
        tabline = {
            lualine_a = {'buffers'},
            lualine_y = {'os.date("%d-%m-%Y %H:%M")'},
            lualine_z = {'tabs'},
        },
     })
     end,
},
-- TELESCOPE
{
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    --requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require("telescope").setup({ defaults = { preview = { filetype_detect = false } } })
    end,
},
--TELESCOPE FILE BROWSER
{ 
    "nvim-telescope/telescope-file-browser.nvim" 
    , event = "VeryLazy"
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
            start_color = "#C1C1C1", end_color = "#2F2F2F",
        },
    },
  },
--COLLAPSER
{
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",  -- or "VeryLazy" if you want
  dependencies = {
    "kevinhwang91/promise-async"
  },
  config = function()
    vim.o.foldcolumn = '1'       -- show fold column
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
      end
    })
  end
},

--LINES SHOWING INDENTATIONS
{
    'nvimdev/indentmini.nvim',
    event = 'BufEnter',
    config = function()
      require('indentmini').setup()
    end,
},   

-----------------------------------------------------------------------------------    
})

require("luasnip.loaders.from_vscode").lazy_load()

require("mason-lspconfig").setup({
  ensure_installed = { "pyright" }
})

local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LSP Setup
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
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
--vim.defer_fn(function()
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

require('indentmini').setup({
  char = '│',
  exclude = { 'markdown', 'help' },
  minlevel = 1,
  only_current = false,
})
vim.api.nvim_set_hl(0, 'IndentLine', { fg = '#2e2e2e' }) -- very dark gray


-- Install the plugin using lazy.nvim
require('lazy').setup({
  'stevearc/vim-arduino',  -- Arduino syntax highlighting and commands
})

require("telescope").load_extension("file_browser")

local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local function spell_suggest()
  local word = vim.fn.expand("<cword>")
  local suggestions = vim.fn.spellsuggest(word)

  if #suggestions == 0 then
    print("No suggestions found for: " .. word)
    return
  end

  pickers.new({}, {
    prompt_title = "Spelling Suggestions for: " .. word,
    finder = finders.new_table {
      results = suggestions
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("normal ciw" .. selection[1])
      end)

      return true
    end,
  }):find()
end

-- Optional: map it to a key like <leader>zs
vim.keymap.set("n", "z=", "<cmd>Telescope spell_suggest<CR>")

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "markdown", "html" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
