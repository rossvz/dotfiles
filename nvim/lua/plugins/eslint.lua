return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            experimental = {useFlatConfig = true},
          },
        },
      },
    },
  },
}
