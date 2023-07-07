return require('telescope').register_extenesion {
  exports = {
    list = require('telescope-highlight-tweaker').list
  }
}
