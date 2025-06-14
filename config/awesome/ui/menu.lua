local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- This is used later as the default terminal and editor to run.
terminal = "/usr/bin/kitty"
editor = os.getenv("EDITOR") or "/usr/bin/nvim"
editor_cmd = terminal .. " -e " .. editor


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", terminal .. " -e man awesome" },
   { "Edit config", editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}


mymainmenu = awful.menu({
  items = {
      { "Awesome", myawesomemenu, beautiful.awesome_icon },
  },
})

--[[secondmenu = awful.menu ({ items = {{ "Powermenu", powermenu, beautiful.powermenu_icon}}})

power_menu = awful.widget.launcher({ image = beautiful.powermenu_icon,
                                      menu = secondmenu})]]

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu, })

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

