local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

beautiful.init(awful.util.get_configuration_dir() .. "theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "/usr/bin/kitty"
editor = os.getenv("EDITOR") or "/usr/bin/nvim"
editor_cmd = terminal .. " -e " .. editor

-- Apps
browser = "/usr/bin/brave"

--Menu-Power
poweroff = "/usr/bin/poweroff"
reset_machine = "/usr/bin/reboot"

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

powermenu = {
  {"Poweroff", poweroff },
  {"Reset", reset_machine },
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Terminal", terminal, beautiful.kitty_icon },
                                    { "Browser", browser, beautiful.brave_icon },
                                    { "Powermenu", powermenu, beautiful.powermenu_icon },
                                  },
                        })

--[[secondmenu = awful.menu ({ items = {{ "Powermenu", powermenu, beautiful.powermenu_icon}}})

power_menu = awful.widget.launcher({ image = beautiful.powermenu_icon,
                                      menu = secondmenu})]]

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu, })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
