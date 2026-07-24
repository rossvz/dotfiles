local last_test_cmd = nil

local function run_test(cmd)
  last_test_cmd = cmd
  vim.cmd("vsplit")
  vim.cmd("terminal " .. cmd)
  vim.cmd("startinsert")
end

local function is_elixir()
  return vim.bo.filetype == "elixir" or vim.bo.filetype == "eelixir" or vim.bo.filetype == "heex"
end

return {
  "nvim-lua/plenary.nvim",
  keys = {
    {
      "<leader>tc",
      function()
        if is_elixir() then
          local file = vim.fn.expand("%:p")
          local line = vim.fn.line(".")
          run_test(string.format("mix test %s:%d", file, line))
        else
          require("neotest").run.run()
        end
      end,
      desc = "[T]est [C]urrent line",
    },
    {
      "<leader>tf",
      function()
        if is_elixir() then
          run_test(string.format("mix test %s", vim.fn.expand("%:p")))
        else
          require("neotest").run.run(vim.fn.expand("%"))
        end
      end,
      desc = "[T]est [F]ile",
    },
    {
      "<leader>tl",
      function()
        if is_elixir() then
          if last_test_cmd then
            run_test(last_test_cmd)
          else
            vim.notify("No previous Elixir test command", vim.log.levels.WARN)
          end
        else
          require("neotest").run.run_last()
        end
      end,
      desc = "[T]est [L]ast",
    },
  },
}
