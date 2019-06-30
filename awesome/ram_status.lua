local wibox = require("wibox")
local awful = require("awful")

local ram_status = wibox.widget{
    widget = wibox.widget.textbox
}

local function format_mem(mem)
    return math.floor(mem / 1000) .. "Mib"
end

awful.widget.watch('bash -c "free | grep -z Mem.*Swap.*"', 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
            stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)")
            widget.markup = string.format(
                "Mem: %s/%s | Swap: %s/%s",
                format_mem(used), format_mem(total), format_mem(used_swap), format_mem(total_swap)
            )
    end,
    ram_status
)

return ram_status