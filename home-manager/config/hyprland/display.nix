{
    wayland.windowManager.hyprland = {
        settings = {
            monitor = [
                "HDMI-A-1, 1920x1080@60, 0x0, 1" # Sceptre
                "HDMI-A-2, 3840x2160@60, 1920x0, 2" # LG
#                "HDMI-A-1, 3840x2160@60.00, 3840x0, 2" # TV
            ];

            exec-once = [
                "xrandr --output HDMI-A-2 --primary"
            ];

            xwayland = {
                force_zero_scaling = true;
            };

            "debug:full_cm_proto" = true;
        };
    };
}
