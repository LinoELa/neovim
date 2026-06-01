-- Picker, explorador y utilidades (folke/snacks.nvim)
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    explorer = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          -- Por defecto el sidebar mide 40 columnas y los nombres se cortan
          layout = {
            preset = "sidebar",
            preview = false,
            layout = {
              width = 52,
              min_width = 52,
            },
          },
          formatters = {
            file = {
              filename_only = true,
              truncate = "left", -- muestra el final del nombre (extensión)
              min_width = 48,
            },
          },
        },
      },
    },
  },
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
  },
}
