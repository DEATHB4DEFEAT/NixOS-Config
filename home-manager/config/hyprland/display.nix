{
    wayland.windowManager.hyprland = {
        settings = {
            monitor = [
                "HDMI-A-2, 1920x1080@60, 0x0, 1" # Sceptre
                "DP-1, 3840x2160@60, 1920x0, 2" # LG
                "HDMI-A-1, 3840x2160@60.00, 3840x0, 2" # TV
            ];

            xwayland = {
                force_zero_scaling = true;
            };
        };
    };
}
