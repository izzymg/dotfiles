# Dotfiles
##### Awesome-wm, rxvt-unicode

## Fonts:

[Leggie](https://github.com/Tecate/bitmap-fonts/tree/master/bitmap)
[Fira Code](https://github.com/tonsky/FiraCode/releases)

I use Croscore fonts for most other things.

## Usage:

Copy and edit the `awesome/` wm theme to .config/

You'll need to remove the exec compton call at the end of rc.lua.

Edit `awesome/isa.lua` (theme file) to set fonts, colors

I also recommend renaming `config/default.lua` to `config/config.lua` to edit it as it's in gitignore - but rc.lua will default to the default file.

Copy `Xresources` to `~/.Xresources`, edit and run `xrdb -merge .Xresources`

My ps1 is in bashrc

For neovim, copy init.vim to `~/.config/nvim`, and install vim plugged or edit it out.
