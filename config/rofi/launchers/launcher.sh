#!/bin/sh

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

# Available Styles
#
# >> Edit these files and uncomment the desired colors/style.
#

#style=style_icons_blur
#style=style_icons_full
#style=style_icons_rainbow
#style=style_icons_rainbow_sidebar
#style=style_icons_popup
#style=style_normal
#style=style_normal_grid
#style=style_normal_grid_full
#style=style_normal_grid_full_round
style=style_normal_grid_round
#style=style_normal_purple
#style=style_normal_purple_alt
#style=style_normal_rainbow
#style=style_normal_rainbow_sidebar

rofi -fake-transparency -no-lazy-grab -show drun -theme launchers/"$style".rasi
