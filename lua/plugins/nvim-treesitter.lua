
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "python",
        "rust",
        "typescript",
        "tsx",
        "vim",
        "jsonc",
        "json",
        "yaml",        
          "markdown",
          "markdown_inline",
      },
      highlight = { enable = true },
      auto_install = true,
      indent = { enable = true },
    })
  end,
}
