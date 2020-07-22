#!/bin/bash
mid="$(($(xwininfo -root | awk '/Width/ { print $2}')))" # 960
width=$1 # 50%
padding=$((100-width)) #
one_side=$(($padding/2)) # 25%
left_offset=$(($mid/100)) # 960 * 0.25
xoffset=$(($left_offset*one_side))
rofi -modi emoji -xoffset  $xoffset -width $width -columns 5 -lines 1 -show run
