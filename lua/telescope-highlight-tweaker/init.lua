local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local make_entry = require('telescope.make_entry')
local utils = require('telescope.utils')
local action_set = require('telescope.actions.set')

local M = {}

local ns_id = vim.api.nvim_create_namespace('telescope-highlight-tweaker')
vim.api.nvim_set_hl_ns(ns_id)

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)

  if not ok then
    return
  end

  return hl
end


function M.list(opts)
  local prev_selection = nil
  local prev_hl_value = nil
  opts = opts or {}

  local function handle_hl_reset(selection)
    if prev_selection ~= nil then
      local args = { prev_selection.value }
      local hl_value = ""

      if prev_hl_value ~= nil then
        for key, value in pairs(prev_hl_value) do
          if key == 'foreground' then
            key = 'guifg'
            value = string.format("#%06x", value)
          elseif key == 'background' then
            key = 'guibg'

            if value ~= 'NONE' then
              value = string.format("#%06x", value)
            end
          elseif key == 'bold' or key == 'italic' or key == 'underline' or key == 'strikethrough' then
            value = key
            key = 'gui'
          end

          if type(key) ~= 'boolean' then
            hl_value = hl_value .. tostring(key) .. "=" .. tostring(value) .. " "
          end
        end

        table.insert(args, hl_value)
      end

      vim.api.nvim_cmd({
        cmd = "highlight",
        args = args,
      }, {})
    end

    prev_selection = selection
    prev_hl_value = get_hl(selection.value)

    if prev_hl_value and prev_hl_value["background"] == nil then
      prev_hl_value["background"] = 'NONE'
    end
  end

  pickers.new(opts, {
    promt_title = 'Edit Highlight Groups',
    finder = finders.new_table {
      results = vim.fn.getcompletion('', 'highlight'),
      entry_maker = opts.entry_maker or make_entry.gen_from_highlights(),
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.move_selection_next:replace(function()
        action_set.shift_selection(prompt_bufnr, 1)

        local selection = action_state.get_selected_entry()

        if selection == nil then
          utils.__warn_no_selection('highlight tweaker')

          return
        end

        handle_hl_reset(selection)

        vim.api.nvim_cmd({
          cmd = "highlight",
          args = { selection.value, "guibg=#4f4f4f" },
        }, {})
      end)

      actions.move_selection_previous:replace(function()
        action_set.shift_selection(prompt_bufnr, -1)

        local selection = action_state.get_selected_entry()

        if selection == nil then
          utils.__warn_no_selection('highlight tweaker')

          return
        end

        handle_hl_reset(selection)

        vim.api.nvim_cmd({
          cmd = "highlight",
          args = { selection.value, "guibg=#4f4f4f" },
        }, {})
      end)

      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()

        if selection == nil then
          utils.__warn_no_selection('highlight tweaker')

          return
        end

        actions.close(prompt_bufnr)

        local hl_value = vim.fn.input("(" .. selection.value .. ") Set new highligh values: ")

        vim.api.nvim_cmd({
          cmd = "highlight",
          args = { selection.value, hl_value },
        }, {})
      end)

      actions.close:replace(function()
        -- Original function from telescope.actions
        local picker = action_state.get_current_picker(prompt_bufnr)
        local original_win_id = picker.original_win_id
        local cursor_valid, original_cursor = pcall(vim.api.nvim_win_get_cursor, original_win_id)

        actions.close_pum(prompt_bufnr)

        require('telescope.pickers').on_close_prompt(prompt_bufnr)

        pcall(vim.api.nvim_set_current_win, original_win_id)

        if cursor_valid and vim.api.nvim_get_mode() == 'i' and picker._original_mode ~= 'i' then
          pcall(vim.api.nvim_win_set_cursor, original_win_id, { original_cursor[1], original_cursor[2] + 1 })
        end
        --

        local selection = action_state.get_selected_entry()

        if selection == nil then
          utils.__warn_no_selection('highlight tweaker')

          return
        end

        handle_hl_reset(selection)
      end)

      return true
    end,
  }):find()
end

return M
