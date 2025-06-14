local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local modkey = "Mod4"

local module = {}

local generate_filter = function(t)
    return function(c)
        local ctags = c:tags()
        for _, v in ipairs(ctags) do
            if v == t then
                return true
            end
        end
        return false
    end
end

-- Create specific tag for tasklist
local fancytasklist = function(cfg, t)
    return awful.widget.tasklist({
        screen = cfg.screen or awful.screen.focused(),
        filter = generate_filter(t),
        buttons = awful.util.table.join(
            awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", {raise = true})
                end
            end),
            awful.button({}, 3, function(c) c:kill() end)
        ),
        layout = {
            spacing = dpi(8),
            layout = wibox.layout.fixed.horizontal
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
            layout = wibox.layout.fixed.vertical,
            create_callback = function(self, c, _, _)
                self:get_children_by_id("clienticon")[1].client = c
                awful.tooltip({
                    objects = { self },
                    timer_function = function()
                        return c.name
                    end,
                })
            end,
        },
    })
end

-- Main function to create widget
function module.new(config)
    local cfg = config or {}
    local s = cfg.screen or awful.screen.focused()

    return awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox,
                        },
                        {
                            id = "tasklist_placeholder",
                            layout = wibox.layout.flex.horizontal,
                        },
                        layout = wibox.layout.align.vertical,
                    },
                    widget = wibox.container.place,
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            layout = wibox.layout.flex.horizontal,

            create_callback = function(self, _, index, _)
                local t = s.tags[index]
                local text_widget = self:get_children_by_id("text_role")[1]
                local tasklist_placeholder = self:get_children_by_id("tasklist_placeholder")[1]

                -- Agregar tasklist solo una vez
                tasklist_placeholder:reset()
                tasklist_placeholder:add(fancytasklist(cfg, t))

                -- Función que actualiza la visibilidad de los widgets
                local update_display = function()
                    local has_clients = #t:clients() > 0
                    text_widget.visible = not has_clients
                    tasklist_placeholder.visible = has_clients
                end

                -- Llamar la función al principio
                update_display()

                -- Conectar las señales para actualizar dinámicamente
                t:connect_signal("tagged", update_display)
                t:connect_signal("untagged", update_display)
                t:connect_signal("property::selected", update_display)

                -- Manejar clientes no gestionados
                client.connect_signal("unmanage", function(c)
                    if c.first_tag == t then
                        update_display()
                    end
                end)
            end,
        },
        buttons = awful.util.table.join(
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
          if client.focus then client.focus:move_to_tag(t) end
      end),
      awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
          if client.focus then client.focus:toggle_tag(t) end
      end),
      awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
    )
    })
end

return module
