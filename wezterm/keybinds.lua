-- keybinds.lua
local wezterm = require 'wezterm'

return {
  keys = {
    { key = 'c', mods = 'SUPER', action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'v', mods = 'SUPER', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = 'k', mods = 'SUPER', action = wezterm.action.ClearScrollback 'ScrollbackOnly' },
    { key = 'k', mods = 'SUPER|SHIFT', action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },
  },
  key_tables = {
    copy_mode = {
      --
    },
    search_mode = {
      --
    },
  }
}
