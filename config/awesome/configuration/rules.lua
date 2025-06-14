local awful = require("awful")

-- Rules to apply to new clients.
awful.rules.rules = {
  {
      rule = { },
      properties = {
          focus = awful.client.focus.filter,
          raise = true,
          screen  = awful.screen.preferred,
          keys = clientkeys,
          buttons = clientbuttons,
          placement = function(c)
              awful.placement.no_overlap(c)
              awful.placement.no_offscreen(c)
          end
      }
  },

  -- Floating clients.
  {
      rule_any = {
          instance = { "copyq", "pinentry" },
          class = {
              "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
              "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
          },
          name = {
              "Event Tester","Open File", "Abrir archivo"
          },
          role = {
              "AlarmWindow", "ConfigManager", "pop-up", "GtkFileChooserDialog"
          }
      },
      properties = {
          floating = true,
          placement = awful.placement.centered
      }
  },

}
