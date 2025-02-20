require("set")

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'tpope/vim-fugitive',
    'mbbill/undotree',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python',
    'github/copilot.vim',
    { "nvim-neotest/nvim-nio" },
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    {
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd.colorscheme 'kanagawa-wave'
        end,
    },
    { 'folke/which-key.nvim',          opts = {} },
    { 'rmagatti/auto-session',         opts = {} },
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x',                       dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'numToStr/Comment.nvim',         opts = {} },
    { 'zadirion/Unreal.nvim',          dependencies = { 'tpope/vim-dispatch' } },

    {
      'tzachar/local-highlight.nvim',
       config = function()
        require('local-highlight').setup()
       end
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    }
})



require("remap")
require("treesitter")
require("lsp")
require("harpoonBindings")
require('nvim-treesitter.install').compilers = { "clang" }
require('dap-python').setup('python')
require('dap_config')
table.insert(require('dap').configurations.python, {
  justMyCode = false
})
require('colors')
require('copilot_setup')
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
require('local-highlight').setup({
    cw_hlgroup = nil,
    insert_mode = false,
    min_match_len = 1,
    max_match_len = math.huge,
    highlight_single_match = true,
})
