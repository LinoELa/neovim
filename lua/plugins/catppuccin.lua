-- Tema catppuccin. LazyVim trae otro tema por defecto; este lo fuerza al cargar.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      no_italic = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = false,
        mini = { enabled = true },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
