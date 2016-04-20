
HD_SCREEN_SIZE_LIST="1280x720 1600x900 1920x1080"


for screen_size in $HD_SCREEN_SIZE_LIST
do
    xrandr | grep $screen_size > /dev/null
    if [ $? -ne 0 ]
    then
        GTF_DATA="$(gtf $(echo $screen_size | tr 'x' ' ') 60 | grep Modeline | cut -d\" -f3 2> /dev/null)"
        if [ ! -z "$GTF_DATA" ]
        then
            xrandr --newmode "$screen_size" $GTF_DATA
            xrandr --addmode $(xrandr | grep " connected" | cut -d\  -f1) $screen_size
        fi
    fi
done
