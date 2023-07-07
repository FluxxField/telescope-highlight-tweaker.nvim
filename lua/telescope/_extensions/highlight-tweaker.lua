local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)')
end

local list = require('telescope-highlight-tweaker').list

return telescope.register_extension {
  exports = {
    list = list,
  }
}
