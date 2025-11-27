AUTOCLICKER_ACTIVE=false
LAST_META_PRESS_TIME=0
LAST_D_PRESS_TIME=0
TOGGLE_THRESHOLD_MS=200

sudo ydotoold &

kill_ydotoold() {
    echo "Cleaning up ydotoold on EXIT"
    sudo killall ydotoold
}

start_autoclicker() {
    echo "Starting autoclicker..."
    hyprctl notify "1 2500 rgb(00ff00) fontsize:50 Autoclicker started"
    sleep .1
    AUTOCLICKER_ACTIVE=true
    if [ -n "$AUTOCLICKER_PID" ] && kill -0 "$AUTOCLICKER_PID" 2>/dev/null; then
        echo "Autoclicker already running. Not starting a new one."
        return
    fi

    (
        while $AUTOCLICKER_ACTIVE; do
            sudo ydotool click 0xc0 >>/dev/null
        done
    ) &
    AUTOCLICKER_PID=$!
    echo "Autoclicker PID: $AUTOCLICKER_PID"
}

stop_autoclicker() {
    echo "Stopping autoclicker..."
    hyprctl notify "1 2500 rgb(ff0000) fontsize:50 Autoclicker stopped"
    AUTOCLICKER_ACTIVE=false
    if [ -n "$AUTOCLICKER_PID" ] && kill -0 "$AUTOCLICKER_PID" 2>/dev/null; then
        kill "$AUTOCLICKER_PID"
        wait "$AUTOCLICKER_PID" 2>/dev/null
        echo "Autoclicker process killed."
    fi
    AUTOCLICKER_PID=""
}

trap stop_autoclicker EXIT
trap kill_ydotoold EXIT

sudo libinput debug-events --show-keycodes | while read -r line; do
    CURRENT_TIME=$(date +%s%3N) # Current time in milliseconds

    if [[ "$line" =~ "KEYBOARD_KEY" ]]; then
        if [[ "$line" =~ "KEY_LEFTMETA" && "$line" =~ "pressed" ]]; then
            LAST_META_PRESS_TIME=$CURRENT_TIME
            if (( CURRENT_TIME - LAST_D_PRESS_TIME < TOGGLE_THRESHOLD_MS )); then
                if $AUTOCLICKER_ACTIVE; then
                    stop_autoclicker
                else
                    start_autoclicker
                fi
                LAST_META_PRESS_TIME=0
                LAST_D_PRESS_TIME=0
            fi
        elif [[ "$line" =~ "KEY_D" && "$line" =~ "pressed" ]]; then
            LAST_D_PRESS_TIME=$CURRENT_TIME
            if (( CURRENT_TIME - LAST_META_PRESS_TIME < TOGGLE_THRESHOLD_MS )); then
                if $AUTOCLICKER_ACTIVE; then
                    stop_autoclicker
                else
                    start_autoclicker
                fi
                LAST_META_PRESS_TIME=0
                LAST_D_PRESS_TIME=0
            fi
        fi
    fi
done
