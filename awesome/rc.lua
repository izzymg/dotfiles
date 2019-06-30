-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Critical error during startup",
        text = awesome.startup_errors
    })
end

-- Error handling
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Critial error",
            text = tostring(err) }
        )
        in_error = false
    end)
end
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/isa.lua")

local network_status = require("network_status")
local ram_status = require("ram_status")

-- Try to pull configuration, pull default conf and notify on failure
local isa_conf_status, isa_conf = pcall(require, "config.config")
if not isa_conf_status then
    isa_conf = require("config.default")
    naughty.notify({
        preset = naughty.config.presets.low,
        title = "Configuration",
        text = "Failed to load config/config.lua, loaded from default"
    })
end

terminal = isa_conf.terminal or "xterm"
modkey = isa_conf.modkey or "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


clickmenu = awful.menu({
    items = {
        { "Term", terminal },
        { "Firefox",
            function()
                awful.spawn.with_shell("firefox", false)
            end
        },
        { "Screenshot",
            function()
                run_screenshot(false)
            end
        },
        { "Hotkeys",
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end
        },
        { "Restart", awesome.restart },
        { "Quit",
            function()
                awesome.quit()
            end
        }
    }
})
-- Menubar configuration
menubar.utils.terminal = terminal

-- Wibar
-- Create a textclock widget
textclock = wibox.widget.textclock()

-- Blank space
textseparator = wibox.widget{
    text = "   ",
    widget = wibox.widget.textbox
}

local function run_screenshot(fullscreen)
    -- Default to selection
    local flag = "-s"
    local notif = "Selecting area for screenshot"
    if fullscreen then
        notif = "Screenshot"
        -- Multiple monitor stitch flag
        flag = "-m"
    end
    naughty.notify({
        preset = naughty.config.presets.low,
        title = "Screenshot",
        text = notif
    })
    -- https://www.reddit.com/r/awesomewm/comments/7ktca8/hotkey_for_scrot_s_not_working_while_scrot_and/
    awful.spawn.with_shell("sleep 0.2 && scrot " .. flag .. " -e 'mv $f ~/pictures/screenshots/ss.$$(date +%d-%m-%y.%H:%M:%S).png'", false)
end


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1,
        function(t) t:view_only() end
    ),
    awful.button({ modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    { raise = true }
                )
            end
        end
    ),
    awful.button({ }, 3,
        function()
            awful.menu.client_list({ theme = { width = 250 } })
        end
    ),
    awful.button({ }, 4,
        function ()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button({ }, 5,
        function ()
            awful.client.focus.byidx(-1)
        end
    )
)

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        -- Allow wallpaper tiling
        if beautiful.wallpaper_tiled_offset ~= nil then
            gears.wallpaper.tiled(wallpaper, s, wallpaper_tiled_offset)
        else
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])

    -- Create a promptbox for each screen
    s.runpromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(
        gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
        )
    )
    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.wibox_tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            spacing = 0,
            layout = wibox.layout.fixed.horizontal
        },
        style = {
            tasklist_disable_icon = true,
        }
    }

    -- Create the wibox
    s.top_wibox = awful.wibar({
        position = beautiful.topbar_position or "top",
        screen = s,
        height = beautiful.topbar_height or 20,
        bg = beautiful.topbar_bg
    })

    -- Add widgets to the wibox
    s.top_wibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
            s.runpromptbox,
        },
        s.wibox_tasklist, -- Middle widget
        { -- Right widgets
            wibox.widget.systray(),
            textseparator,
            ram_status,
            textseparator,
            layout = wibox.layout.fixed.horizontal,
            network_status,
            textclock,
            s.layoutbox,
        },
    }
end)

-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () clickmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              { description="show help", group="awesome" }),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              { description = "view previous", group = "tag" }),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              { description = "view next", group = "tag" }),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              { description = "go back", group = "tag" }),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey,           }, "w", function () clickmenu:show() end,
              { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", { raise = true }
                    )
                  end
              end,
              { description = "restore minimized", group = "client" }),

    -- Run prompt
    awful.key({ modkey }, "r",
        function ()
            awful.screen.focused().runpromptbox:run()
        end,
        { description = "run prompt", group = "launcher" }
    ),

    -- Terminal
    awful.key({ modkey }, "Return",
        function ()
            awful.spawn(terminal)
        end,
        { description = "open a terminal", group = "launcher" }
    ),

    -- Dmenu
    awful.key({ modkey }, "x",
        function ()
            awful.spawn(string.format("dmenu_run %s", isa_conf.dmenu_string))
        end,
        { description = "Dmenu", group = "awesome" }
    ),

    -- Scrot
    awful.key({  }, "Print",
        function()
            run_screenshot(false)
        end,
        { description = "scrot", group = "awesome" }
    ),
    awful.key({ "Shift" }, "Print",
        function ()
            run_screenshot(true)
        end,
        { description = "scrot", group = "awesome" }
    )
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              { description = "move to master", group = "client" }),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              { description = "move to screen", group = "client" }),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  { description = "view tag #"..i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  { description = "move focused client to tag #"..i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)


-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    { rule = { class = "discord" },
        properties = { screen = 1, tag = "3" } },
}


-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    local titlebar = awful.titlebar(c, {
        size = beautiful.titlebar_size or 25
    })

    titlebar:setup {
        -- Left
        {
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        -- Middle
        {
            {
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        -- Right
        {
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
