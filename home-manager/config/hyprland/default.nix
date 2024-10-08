{
    imports = [
        ./keybinds.nix
        ./mousebinds.nix
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            env = [
                # "LIBVA_DRIVER_NAME,nvidia"
                "XDG_SESSION_TYPE,wayland"
                # "GBM_BACKEND,nvidia-drm"
                # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
                "WLR_NO_HARDWARE_CURSORS,1"
                "ELECTRON_OZONE_PLATFORM_HINT,auto"
            ];

            monitor = [
                "HDMI-A-1,1920x1080@60,0x0,1"
                "DP-3,3840x2160@60,1920x0,2"
            ];

            xwayland = {
                force_zero_scaling = true;
            };
        };
    };
}
