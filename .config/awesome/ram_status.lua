local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local ram_status = wibox.widget{
    widget = wibox.widget.textbox
}

local success_color = beautiful.success_text_color or "green"
local error_color = beautiful.error_text_color or "red"

local function format_mem(mem)
    return math.floor(mem / 1000) .. "MB"
end

local function format_used(used, total)
    local percent_used = math.floor((used / total) * 100)
    local used_fmt = format_mem(used)
    if percent_used > 55 then
        return string.format("<span color='%s'>%s</span>", error_color, used_fmt)
    else
        return string.format("<span color='%s'>%s</span>", success_color, used_fmt)
    end
end

awful.widget.watch('bash -c "free | grep -z Mem.*Swap.*"', 1,
    function(widget, out, err, reason, code)
        local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
            string.match(out, "(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)")
        widget.markup = string.format(
            "Mem: %s/%s Swap: %s/%s",
            format_used(used, total), format_mem(total), format_mem(used_swap), format_mem(total_swap)
        )
    end,
    ram_status
)

return ram_status