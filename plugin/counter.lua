-- ~/.config/nvim/lua/myplugins/wordcount.lua
vim.api.nvim_create_user_command("WordCount", function()
  local buf = vim.api.nvim_get_current_buf()
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
  local word_count = select(2, string.gsub(text, "%S+", ""))
  local char_count = #text
  print("Words: " .. word_count .. " | Characters: " .. char_count)
end, {})

