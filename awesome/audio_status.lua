local wibox = require("wibox")
local awful = require("awful")

local audio_status = wibox.widget{
    widget = wibox.widget.textbox
}

awful.widget.watch("bash -c 'pulsemixer --get-mute --get-volume'", 1,
    function(widget, out, err, reason, code)

        -- Split mute status on first line from vol status on second
        local newline = string.find(out, "\n") + 1
        local mute_line = string.sub(out, 1, 1)

        local volume = "Muted"

        if mute_line ~= "1" then
            local volume_line = string.sub(out, newline, string.len(out))
            local first_space = string.find(volume_line, " ") - 1
            volume = string.sub(volume_line, 1, first_space) .. "%"
        end

        widget.markup = string.format(
            "Volume: <b>%s</b>",
            volume
        )
    end,
    audio_status
)

return audio_status