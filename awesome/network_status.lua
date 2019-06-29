local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- Network widgets

local active_network = wibox.widget{
    widget = wibox.widget.textbox,
}

local ping_success = wibox.widget{
    widget = wibox.widget.textbox,
}

local success_color = beautiful.success_text_color or "green"
local error_color = beautiful.error_text_color or "red"

-- Main layout
local network_status = wibox.widget{
    ping_success,
    wibox.widget.textbox(" | "),
    active_network,
    layout = wibox.layout.fixed.horizontal   
}

local function update_ping_status()
    awful.spawn.easy_async_with_shell(
        "ping -c 1 8.8.8.8",
        function(out, err, reason, code)
            ping_status = string.format("<span color='%s'>Internet reachable", success_color)
            if code ~= 0 then
                ping_status = string.format("<span color='%s'>Internet unreachable", error_color)
            end
            ping_status = ping_status .. "</span>"
            ping_success.markup = ping_status
        end
    )
end

local function update_active_network_status()
    -- Active network profiles start with a *
    awful.spawn.easy_async_with_shell(
        "netctl list | grep '^*'",
        function(out, err, reason, code)
            stripped_output = string.sub(out, 3, string.len(out) - 1)
            if string.len(stripped_output) > 0 then
                active_network.markup = string.format("Network: <b>%s</b>", stripped_output)
            else
                active_network.markup = "<b>No network</b>"
            end
        end
    )
end

local function update()
    ping_success.markup = "<b>Polling...</b>"
    update_active_network_status()
    update_ping_status()
end

local timer = gears.timer{
    timeout = 25,
    call_now = true,
    autostart = true,
    callback = update
}

network_status:connect_signal('button::press', update)

return network_status