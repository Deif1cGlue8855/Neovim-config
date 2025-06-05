-- ~/.config/nvim/lua/myplugins/counterLine.lua
local M = {}

function M.get_counts()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Check if buffer is valid and loaded
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return "W:0 C:0"
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if not lines or #lines == 0 then
    return "W:0 C:0"
  end

  local text = table.concat(lines, "\n")
  local word_count = select(2, string.gsub(text, "%S+", ""))
  local char_count = #text

  return "W:" .. word_count .. " C:" .. char_count
end

return M

