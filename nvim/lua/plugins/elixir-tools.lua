-- Dexter LSP for Elixir (https://github.com/remoteoss/dexter)
-- Replaces ElixirLS / Expert / Next LS. Binary must be on $PATH.
-- Install:
--   brew install remoteoss/tap/dexter
--   # or: mise plugin add dexter https://github.com/remoteoss/dexter.git && mise use -g dexter@latest
--   # or: asdf plugin add dexter https://github.com/remoteoss/dexter.git && asdf install dexter latest

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Turn off ElixirLS from the LazyVim elixir extra
        elixirls = { enabled = false },

        dexter = {
          mason = false,
          cmd = { "dexter", "lsp" },
          filetypes = { "elixir", "eelixir", "heex" },
          root_markers = { ".dexter/dexter.db", ".dexter.db", "mix.exs", ".git" },
          init_options = {
            followDelegates = true,
            -- stdlibPath = "",   -- override Elixir stdlib path
            -- debug = false,     -- verbose logging to stderr
          },
        },
      },
    },
  },

  -- Keep elixir-tools.nvim fully disabled — it bundles elixir-ls + next-ls.
  {
    "elixir-tools/elixir-tools.nvim",
    enabled = false,
  },
}
