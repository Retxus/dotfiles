local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local modkey = "Mod4"

local module = {}

local generate_filter = function(t)
    return function(c)
        for _, v in ipairs(c:tags()) do
            if v == t then
                return true
            end
        end
        return false
    end
end

local tasklist = function(cfg, t)
    return awful.widget.tasklist({
        screen = cfg.screen or awful.screen.focused(),
        filter = generate_filter(t),
        buttons = {
            awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c.minimized = false
                    c:emit_signal('request::activate')
                    c:raise()
                end
            end),
            awful.button({}, 2, function(c)
                c:kill()
            end),
        },
        layout = {
            spacing_widget = nil,
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            {
                {
                    id = "clienticon",
                    forced_height = dpi(28),
                    forced_width = dpi(28),
                    widget = awful.widget.clienticon,
                },
                widget = wibox.container.place,
            },
            widget = wibox.container.margin,
              {
                  id = "background_role",
                  widget = wibox.container.background,
              },
            layout = wibox.layout.align.vertical,
            
        },
    })
end

function module.new(config)
    local cfg = config or {}

    local s = cfg.screen or awful.screen.focused()

    return awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        widget_template = {
            {
                {
                    -- Text role for tag number
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    -- Tasklist placeholder
                    {
                        id = "tasklist_placeholder",
                        layout = wibox.layout.fixed.horizontal,
                    },
                    layout = wibox.layout.align.vertical,
                    align = "center",
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            layout = wibox.layout.flex.horizontal,
            create_callback = function(self, _, index, _)
                local t = s.tags[index]
                local tasklist_widget = self:get_children_by_id("tasklist_placeholder")[1]
                local text_widget = self:get_children_by_id("text_role")[1]


                -- Add tasklist to the placeholder
                tasklist_widget:add(tasklist(cfg, t))

                -- Update dynamically based on the number of clients
                local update_display = function()
                    if #t:clients() > 0 then
                        -- Hide the number and show icons
                        text_widget.visible = false
                        tasklist_widget.visible = true
                    else
                        -- Show the number and hide icons
                        text_widget.visible = true
                        tasklist_widget.visible = false
                    end
                end

                -- Call it once and connect signals to keep it updated
                update_display()
                t:connect_signal("tagged", update_display)
                t:connect_signal("untagged", update_display)
            end,
        },
        buttons = {
            awful.button({}, 1, function(t)
                t:view_only()
            end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({}, 4, function(t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function(t)
                awful.tag.viewnext(t.screen)
            end),
        },
    })
end

return module
