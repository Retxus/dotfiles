local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

require("ui.menu")
require("configuration.tags")
-- {{{ Wibar

-- Create a textclock widget
local calendar = require("ui.widgets.calendar")

--screen.connect_signal("request::desktop_decoration", function(s)
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ " ", " ", " ", " ", " ", " "}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

              local fancy_taglist = require("ui.widgets.fancy_taglist")
              s.mytaglist = wibox.widget {
                  widget = wibox.container.place,
                  fancy_taglist.new({
                    screen = s,
                    taglist_buttons = mytagbuttons,
                    tasklist_buttons = mytasklistbuttons,
                  })
              }

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
        screen.primary.mywibar.visible = not vis
    end)

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)

    -- Create the wibox
    s.bar = awful.wibar ({
        type = "dock",
        screen = s,
        height = dpi(40),
        position = "top",
    })

    s.bar:setup({
      {
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          {
              mylauncher,
              margins = dpi(2),
              widget = wibox.container.margin,
          },
          s.mytaglist,
          widget = wibox.container.margin,
          {
              {
                  margins = dpi(10),
                  widget = wibox.container.margin,
              },
              calendar,
              s.mylayoutbox,
              spacing = dpi(10),
              layout = wibox.layout.fixed.horizontal,
          },
        },
        left = dpi(5),
        right = dpi(5),
        widget = wibox.container.margin,
      },
      widget = wibox.container.background,
    })
end)
