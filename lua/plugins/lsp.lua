-- LSP: extiende LazyVim. Mason + servidores (ver @LSP.md, @mason.md)
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "vtsls",
        "rust_analyzer",
        "pyright",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        pyright = {},
      },
    },
  },
}
