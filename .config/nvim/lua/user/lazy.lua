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
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            { "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
            { "lvimuser/lsp-inlayhints.nvim",    branch = "anticonceal" },
        },
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            pcall(require("nvim-treesitter.install").update({ with_sync = true }))
        end,
    },

    { "nvim-lualine/lualine.nvim", dependencies = { "arkav/lualine-lsp-progress" } },
    { "numToStr/Comment.nvim",     opts = {} },
    { "folke/which-key.nvim",      opts = {} },
    "RRethy/nvim-base16",
    "jiangmiao/auto-pairs",
    "ThePrimeagen/harpoon",
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            }, "nvim-telescope/telescope-ui-select.nvim",
        },
    },
}, {})
