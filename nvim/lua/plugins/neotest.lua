return {
  enabled = true,
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "jfpedroza/neotest-elixir",
    "zidhuss/neotest-minitest",
  },
  opts = {
    adapters = {
      ["neotest-jest"] = {
        jestCommand = "node_modules/.bin/jest",
        env = { CI = "true" },
        cwd = function()
          return vim.fn.getcwd()
        end,
      },
      ["neotest-minitest"] = {},
      -- ["neotest-elixir"] = {
      --   args = { "--trace" },
      --   extra_formatters = { "ExUnit.CLIFormatter" },
      --   post_process_command = function(cmd)
      --     return vim.tbl_flatten({ "env", "MIX_ENV=test", cmd })
      --   end,
      -- },
    },
    output = {
      open_on_run = true,
    },
    output_panel = {
      enabled = true,
    },
  },
}
