local beautiful = require("beautiful")
local screen =  screen
local gears = require("gears")

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wp = beautiful.wallpaper
        if type(wp) == "function" then
            wp = wp(s)
        end
        gears.wallpaper.maximized(wp, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

for s in screen do
    set_wallpaper(s)
end
