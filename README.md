# Dotfiles
##### Awesome-wm, rxvt-unicode

## Fonts:

#### Window Manager, GTK-2

[Leggie](https://github.com/Tecate/bitmap-fonts/tree/master/bitmap)

#### Terminal:

[Fira Code](https://github.com/tonsky/FiraCode/releases)

#### VS Code:

[Fira Code](https://github.com/tonsky/FiraCode/releases)

#### Fontconfig (Firefox, GTK-3)

sans-serif: `Noto Sans`

monospace: `Noto Mono`

## Usage:

Copy and edit the `awesome/` wm theme to .config/

You'll need to remove the exec compton call at the end of rc.lua and change any variables or keybinds (dmenu etc)

Edit `awesome/isa.lua` (theme file) to set fonts and so on

Copy `Xresources` to `~/.Xresources`, edit and run `xrdb -merge .Xresources`
