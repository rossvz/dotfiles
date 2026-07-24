-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.b.completion = false
  end,
})

local dexter_group = vim.api.nvim_create_augroup("dexter_format_on_save", { clear = true })

local function attach_dexter_format(client, bufnr)
  if not client or client.name ~= "dexter" then
    return
  end
  if not client:supports_method("textDocument/formatting") then
    return
  end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = dexter_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 5000 })
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = dexter_group,
  callback = function(args)
    attach_dexter_format(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
  end,
})

for _, client in ipairs(vim.lsp.get_clients({ name = "dexter" })) do
  for bufnr, _ in pairs(client.attached_buffers) do
    attach_dexter_format(client, bufnr)
  end
end

vim.api.nvim_create_user_command("DexterCheck", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  print("Clients attached to buffer: " .. #clients)
  for _, c in ipairs(clients) do
    print(string.format(
      "  - %s | formatting=%s | supports_formatting=%s",
      c.name,
      tostring(c.server_capabilities.documentFormattingProvider),
      tostring(c:supports_method("textDocument/formatting"))
    ))
  end
end, {})
