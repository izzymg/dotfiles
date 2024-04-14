local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local themes_path = require("gears.filesystem").get_themes_dir()


local theme = {}
theme.font          = "IBM Plex Mono Bold 9"
theme.accent        = "#9d79d6"
theme.bg_focus      = "#192330"
theme.bg_normal     = "#131a24"
theme.bg_urgent     = "#fce94f"
theme.bg_minimize   = "#0067ce"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#fff"
theme.fg_focus      = "#fff"
theme.fg_urgent     = "#fff"
theme.fg_minimize   = "#fff"

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(2)
theme.border_normal = "#634a5e"
theme.border_focus = theme.accent
theme.border_marked = "#eeeeec"

theme.tasklist_bg_normal = "#212e3f"
theme.tasklist_bg_focus = theme.accent
theme.tasklist_disable_icon = true
theme.tasklist_align = "center"
theme.tasklist_plain_task_name = true

theme.cpu_low = "#81b29a"
theme.cpu_mid = "#63cdcf"
theme.cpu_high = "#c94f6d"

theme.layout_fairh           = themes_path .. "default/layouts/fairh.png"
theme.layout_fairv           = themes_path .. "default/layouts/fairv.png"
theme.layout_floating        = themes_path .. "default/layouts/floating.png"
theme.layout_magnifier       = themes_path .. "default/layouts/magnifier.png"
theme.layout_max             = themes_path .. "default/layouts/max.png"
theme.layout_fullscreen      = themes_path .. "default/layouts/fullscreen.png"
theme.layout_tilebottom      = themes_path .. "default/layouts/tilebottom.png"
theme.layout_tileleft        = themes_path .. "default/layouts/tileleft.png"
theme.layout_tile            = themes_path .. "default/layouts/tile.png"
theme.layout_tiletop         = themes_path .. "default/layouts/tiletop.png"
theme.layout_spiral          = themes_path .. "default/layouts/spiral.png"
theme.layout_dwindle         = themes_path .. "default/layouts/dwindle.png"
theme.layout_cornernw        = themes_path .. "default/layouts/cornernw.png"
theme.layout_cornerne        = themes_path .. "default/layouts/cornerne.png"
theme.layout_cornersw        = themes_path .. "default/layouts/cornersw.png"
theme.layout_cornerse        = themes_path .. "default/layouts/cornerse.png"

theme.awesome_icon           = themes_path .. "default/awesome-icon.png"

-- from default for now...
theme.menu_submenu_icon     = themes_path .. "default/submenu.png"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- MISC
theme.taglist_squares       = "true"
theme.titlebar_close_button = "true"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
