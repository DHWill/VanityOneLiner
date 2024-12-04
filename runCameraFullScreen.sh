#To Remove Screen Blanking
pkill raspivid
xset s off
xset s noblank
xset -dpms

#To Start Camera
# raspivid -w 720 -h 720 --exposure auto --flicker 50hz --awb tungsten -f -t 0
raspivid -w 720 -h 720 --exposure auto --flicker 50hz -f -t 0
# raspivid -w 720 -h 720 -f -t 0
