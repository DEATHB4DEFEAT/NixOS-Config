hl.config{
    monitor = {
        { -- Sceptre
            output = "HDMI-A-1";
            mode = "1920x1080@144";
            position = "0x0";
            scale = "1.0";
        },
        { -- LG
            output = "HDMI-A-2";
            mode = "3840x2160@60";
            position = "1920x0";
            scale = "2.0";
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },

    debug = {
        full_cm_proto = true,
    },
}

EXEC_ALL{
    "xrandr --output HDMI-A-2 --primary",
}
