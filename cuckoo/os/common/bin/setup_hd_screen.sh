
HD_SCREEN_SIZE_LIST_DEFAULT="1920x1080 1600x900 1280x720"
HD_SCREEN_HZ=60


if [ -z "$1" ]
then
    HD_SCREEN_SIZE_LIST="$HD_SCREEN_SIZE_LIST_DEFAULT"
else
    HD_SCREEN_SIZE_LIST="$1"
fi


for screen_size in $HD_SCREEN_SIZE_LIST
do
    xrandr | grep $screen_size > /dev/null
    if [ $? -gt 0 ]
    then
        echo -n "$screen_size "

        GTF_DATA="$(gtf $(echo $screen_size | tr 'x' ' ') $HD_SCREEN_HZ | grep Modeline | cut -d\" -f3 2> /dev/null)"
        if [ ! -z "$GTF_DATA" ]
        then
            xrandr --newmode "$screen_size" $GTF_DATA
            xrandr --addmode $(xrandr | grep " connected" | cut -d\  -f1) $screen_size
            echo "Screen size '$screen_size' has been defined"
        fi
    else
        echo "Screen size '$screen_size' already was defined"
    fi
done


exit 0
