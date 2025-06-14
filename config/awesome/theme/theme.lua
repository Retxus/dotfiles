local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local themes_path = gears.filesystem.get_configuration_dir() .. "theme/"

local theme = {}

-- Colors
theme.crust = "#11111b"
theme.mantle = "#181825"
theme.base = "#1e1e2e"
theme.surface0 = "#313244"
theme.surface1 = "#45475a"
theme.surface2 = "#585b70"
theme.overlay0 = "#6c7086"
theme.overlay1 = "#7f849c"
theme.overlay2 = "#9399b2"
theme.subtext0 = "#a6adc8"
theme.subtext1 = "#bac2de"
theme.text = "#cdd6f4"
theme.lavender = "#b4befe"
theme.blue = "#89b4fa"
theme.shappire = "#74c7ec"
theme.sky = "#89dceb"
theme.teal = "#94e2d5"
theme.green = "#a6e3a1"
theme.yellow = "#f9e2af"
theme.peach = "#fab387"
theme.maroon = "#eba0ac"
theme.red = "#f38ba8"
theme.mauve = "#cba6f7"
theme.pink = "#f5c2e7"
theme.flamingo = "#f2cdcd"
theme.rosewater = "#f5e0dc"
theme.dark = "#000000"
theme.white = "#ffffff"
theme.transparent = "#00000000"

-- Background colors
theme.bg_normal = theme.dark
theme.bg_focus = theme.white
theme.bg_urgent = theme.red

theme.fg_normal = theme.white
theme.fg_focus = theme.dark
theme.fg_urgent = theme.red

theme.useless_gap = dpi(6)
theme.border_width = dpi(0)
theme.border_normal = theme.dark
theme.border_active = theme.dark
theme.border_marked = theme.transparent

-- Taglist
theme.taglist_fg_focus = theme.teal
theme.taglist_bg_focus = theme.transparent
theme.taglist_bg_urgent = theme.transparent

theme.taglist_font = "HackNerdFont 12"

-- Wibar
theme.wibar_bg = theme.surface0
theme.wibar_shape = gears.shape.rounded_rect

--Calendar
theme.calendar_border = theme.lavender
theme.calendar_bg = theme.surface0
theme.calendar_fg = theme.text
theme.calendar_transparent = theme.transparent

-- PowerOff
theme.power_bg = theme.surface0
theme.power_fg = theme.text
theme.power_border = theme.mauve
theme.power_icon = themes_path .. "icons/media/power.png"

--Hotkeys
theme.hotkeys_bg = theme.surface0
theme.hotkeys_border_color = theme.overlay2
theme.hotkeys_modifiers_fg = theme.white
theme.hotkeys_shape = gears.shape.rounded_rect
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_font = "HackNerdFont 10"
theme.hotkeys_description_font = "HackNerdFont 10"
theme.hotkeys_group_margin = dpi(12)

--Awesome menu
theme.menu_submenu_icon = themes_path .. "icons/menu/submenu.png"
theme.menu_font = "HackNerdFont 12"
theme.menu_bg_normal = theme.surface0
theme.menu_bg_focus = theme.surface2
theme.menu_fg_focus = theme.sky
theme.menu_fg_normal = theme.text
theme.menu_height = dpi(22)
theme.menu_width = dpi(160)

-- Wallpaper
theme.wallpaper = themes_path .. "wallpaper.png"

-- You can use your own layout icons like this:
theme.layout_tile = themes_path .. "icons/layouts/tile.png"
theme.layout_tileleft = themes_path .. "icons/layouts/tileleft.png"
theme.layout_floating  = themes_path .. "icons/layouts/floating.png"
theme.layout_tilebottom = themes_path .. "icons/layouts/tilebottom.png"
theme.layout_tiletop = themes_path .. "icons/layouts/tiletop.png"
theme.layout_fairv = themes_path .. "icons/layouts/fair.png"
theme.layout_fairh = themes_path .. "icons/layouts/fairhorizontal.png"
theme.layout_spiral  = themes_path.."icons/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "icons/layouts/spiraldwindle.png"

-- Generate menu icons
theme.awesome_icon = themes_path .. "icons/menu/arch.svg"

theme.icon_theme = nil

return theme
