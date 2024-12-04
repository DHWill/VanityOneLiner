pkill raspivid
xset s noblank
xset -dpms
raspivid -w 720 -h 720 --exposure auto --flicker 50hz --awb tungsten -f -t 0
