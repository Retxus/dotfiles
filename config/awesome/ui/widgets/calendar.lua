local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Textclock
local calendar_text = wibox.widget {
    format = "%I:%M %p",
    widget = wibox.widget.textclock
}
calendar_text.font = "HackNerdFontBold 14"

-- Current date to control the calendar
local current_date = os.date("*t")

-- Function to change the month
local function change_month(offset)
    current_date.month = current_date.month + offset
    if current_date.month > 12 then
        current_date.month = 1
        current_date.year = current_date.year + 1
    elseif current_date.month < 1 then
        current_date.month = 12
        current_date.year = current_date.year - 1
    end
end


-- Calendar widget
local calendar_widget = wibox.widget {
    date = current_date,
    font = "HackNerdFontBold 12",
    spacing = dpi(4),
    fn_embed = function(widget, flag)
        return wibox.widget {
            {
                {
                    widget,
                    widget = wibox.container.place
                },
                margins = dpi(8),
                widget = wibox.container.margin
            },
            shape = (flag == "focus") and gears.shape.circle or nil,
            bg = (flag == "focus") and "#FFFFFF33" or nil,
            widget = wibox.container.background
        }
    end,
    widget = wibox.widget.calendar.month
}

-- Function to create real button with click
local function create_month_button(symbol, offset)
    local text = wibox.widget {
        text = symbol,
        font = "HackNerdFontBold 16",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local container = wibox.widget {
        {
            text,
            margins = dpi(6),
            widget = wibox.container.margin
        },
        bg = "#45475a",
        fg = "#cdd6f4",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    container:buttons(gears.table.join(
        awful.button({}, 1, function()
            change_month(offset)
            calendar_widget.date = nil
            calendar_widget.date = current_date
        end)
    ))

    return container
end

-- Create real buttons
local prev_button = create_month_button("<", -1)
local next_button = create_month_button(">", 1)

-- Popup of calendar
local calendar_popup = awful.popup {
    widget = {
        {
            {
                {
                    prev_button,
                    nil,
                    next_button,
                    layout = wibox.layout.align.horizontal
                },
                margins = dpi(4),
                widget = wibox.container.margin
            },
            calendar_widget,
            spacing = dpi(6),
            layout = wibox.layout.fixed.vertical
        },
        margins = dpi(6),
        widget = wibox.container.margin
    },
    border_color = beautiful.calendar_border,
    border_width = dpi(3),
    placement = function(d)
        awful.placement.align(d, {
            position = "top_right",
            honor_workarea = true,
        })
        d.y = d.y + dpi(10)
        d.x = d.x - dpi(10)
    end,
    shape = gears.shape.rounded_rect,
    visible = false,
    ontop = true,
    bg = beautiful.calendar_bg,
    fg = beautiful.calendar_fg,
}

-- Click catcher to clone calenda
local clic_catcher = wibox {
    ontop = true,
    visible = false,
    bg = beautiful.calendar_transparent,
    type = "dock"
}

clic_catcher:buttons(gears.table.join(
    awful.button({}, 1, function()
        calendar_popup.visible = false
        clic_catcher.visible = false
    end)
))

-- Hide calendar when change tag
tag.connect_signal("property::selected", function()
    if calendar_popup.visible then
        calendar_popup.visible = false
    end
end)

-- Show/Hide calendar when clicking on the clock
local function toggle()
    if calendar_popup.visible then
        calendar_popup.visible = false
        clic_catcher.visible = false
    else
        clic_catcher.screen = mouse.screen
        clic_catcher.width = mouse.screen.geometry.width
        clic_catcher.height = mouse.screen.geometry.height
        clic_catcher.visible = true
        calendar_popup.screen = mouse.screen
        calendar_popup.visible = true
    end
end

calendar_text:buttons(gears.table.join(
    awful.button({}, 1, function()
        toggle()
    end)
))

-- Export
return {
    widget = calendar_text,
    toggle = toggle
}
