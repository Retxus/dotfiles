local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Main button
local power_icon = wibox.widget {
    {
        image = beautiful.power_icon,
        resize = true,
        widget = wibox.widget.imagebox,
        forced_width = dpi(28),
        forced_heigth = dpi(28)
    },
    widget = wibox.container.place
}

local poweroff_button = wibox.widget {
    {
        {
            text = "PowerOff",
            align = "center",
            font = "HackNerdFont 12",
            widget = wibox.widget.textbox,
        },
        margins = dpi(10),
        widget = wibox.container.margin
    },
    bg = beautiful.power_bg,
    fg = beautiful.power_fg,
    widget = wibox.container.background
}

local reboot_button = wibox.widget {
    {
        {
            text = "Reboot",
            align = "center",
            font = "HackNerdFont 12",
            widget = wibox.widget.textbox,
        },
        margins = dpi(10),
        widget = wibox.container.margin
    },
    bg = beautiful.power_bg,
    fg = beautiful.power_fg,
    widget = wibox.container.background
}

poweroff_button:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("/usr/bin/poweroff")
    end)
))

reboot_button:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("/usr/bin/reboot")
    end)
))

local power_menu = awful.popup {
    widget = {
        {
            poweroff_button,
            reboot_button,
            spacing = dpi(2),
            layout = wibox.layout.fixed.vertical
        },
        margins = dpi(8),
        widget = wibox.container.margin
    },
    border_color = beautiful.power_border,
    border_width = dpi(2),
    shape = gears.shape.rounded_rect,
    visible = false,
    ontop = true,
    bg = beautiful.power_bg,
    placement = function(p)
        awful.placement.align(p, {
            position = "top_right",
            honor_workarea = true,
        })
        p.y = p.y + dpi(10)
        p.x = p.x - dpi(10)
    end
}

local clic_catcher = wibox {
    ontop = true,
    visible = false,
    bg = beautiful.calendar_transparent,
    type = "dock"
}

clic_catcher:buttons(gears.table.join(
    awful.button({}, 1, function()
        power_menu.visible = false
        clic_catcher.visible = false
    end)
))

-- Hide power_menu when change tag
tag.connect_signal("property::selected", function()
    if power_menu.visible then
        power_menu.visible = false
        power_menu.visible = false
    end
end)

local function toggle_power_menu()
    if power_menu.visible then
        power_menu.visible = false
        clic_catcher.visible = false
    else
        clic_catcher.screen = mouse.screen
        clic_catcher.width = mouse.screen.geometry.width
        clic_catcher.height = mouse.screen.geometry.height
        clic_catcher.visible = true
        power_menu.screen = mouse.screen
        power_menu.visible = true
    end
end

power_icon:buttons(gears.table.join(
    awful.button({}, 1, function()
        toggle_power_menu()
    end)
))

return power_icon
