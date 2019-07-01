# Izzy Dotfiles
##### Awesome-wm, rxvt-unicode

## Fonts:

[Leggie](https://github.com/Tecate/bitmap-fonts/tree/master/bitmap)
[Tewi](https://github.com/lucy/tewi-font)
[Fira Code](https://github.com/tonsky/FiraCode/releases)

I use Croscore fonts for most other things.

## Awesome WM

Edit `.config/awesome/isa.lua` (theme file) to set fonts, colors

I also recommend renaming `config/default.lua` to `config/config.lua` to edit it as it's in gitignore - but rc.lua will default to the default file.

## XResources etc

Copy `.Xresources` to `~/.Xresources`, edit and run `xrdb -merge .Xresources`

I also have some stripped down versions of the .bashrc files I use, for both my home user and root. Mainly just the PS1, and an alias that enforces neovim on my user and vim on root.

## Neovim

For neovim, copy init.vim to `~/.config/nvim`, and install vim plugged or edit out the calls to it.

## FontConfig

Install ttf-croscore fonts, and add the local.conf settings to `/etc/fonts/local.conf`, which will substitute fonts for Arimo, Tinos and Fira Code.

Subjective ofc
