#!/bin/bash

echo -e "\nconfiguring touchscreen colibration matrix..."
xinput set-prop 'DIALOGUE INC PenMount USB' 'Coordinate Transformation Matrix' 1.220 0.0 -0.10549 0.0 1.265934 -0.132143 0.0 0.0 1.0

echo -e "\nconfiguring display gamma values"
xrandr --output eDP-1 --gamma 0.8:0.8:0.8

exit 0
