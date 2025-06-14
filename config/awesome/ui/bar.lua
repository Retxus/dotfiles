local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

require("ui.menu")
require("configuration.layouts")

-- Load widgets widget
local calendar = require("ui.widgets.calendar")
local power = require("ui.widgets.power")

--screen.connect_signal("request::desktop_decoration", function(s)
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ " ", " ", " ", " ", " ", " "}, s, awful.layout.layouts[1])

    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)

    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc(-1) end),
        awful.button({ }, 5, function () awful.layout.inc( 1) end)
    ))

    local fancy_taglist = require("ui.widgets.fancy_taglist")
    s.mytaglist = fancy_taglist.new({ screen = s })

    -- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.bar.visible = false
        else
            c.screen.bar.visible = true
        end
    end

    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.bar.visible = true
        end
    end

    -- Hide bar when a splash widget is visible
    awesome.connect_signal("widgets::splash::visibility", function (vis)
        screen.primary.bar.visible = not vis
    end)

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)

    -- Create the wibar
    s.bar = awful.wibar({
        type = "dock",
        screen = s,
        ontop = true,
        position = "top",
        height = dpi(40),
        visible = true,
        width = s.geometry.width - (3 * beautiful.useless_gap),
    })

    s.bar.y = dpi(6)

    s.bar:setup({
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            {
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
            },
            s.mytaglist,
            {
                calendar.widget,
                power,
                s.mylayoutbox,
                spacing = dpi(14),
                layout = wibox.layout.fixed.horizontal,
            },
        },
        widget = wibox.container.background,
    })
end)
