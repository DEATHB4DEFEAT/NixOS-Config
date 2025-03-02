{
    lib,
    pkgs,
    ...
}:

{
    imports = [
        ./keybinds.nix
        ./mousebinds.nix
    ];


    home.packages = with pkgs; [
        playerctl
        brightnessctl
        # Theming
        kdePackages.qtstyleplugin-kvantum
        kdePackages.qt6ct
        (catppuccin-kvantum.override {
            accent = "mauve";
            variant = "mocha";
        })

        hyprland-qtutils
        hyprshot
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;

        settings =
            let
                inherit (import ./variables.nix)
                    #browser #TODO
                    #terminal #TODO
                    keyboardLayout
                ;
        in
        {
            env = [
                # "LIBVA_DRIVER_NAME, nvidia"
                # "GBM_BACKEND, nvidia-drm"
                # "__GLX_VENDOR_LIBRARY_NAME, nvidia"
                "WLR_NO_HARDWARE_CURSORS, 1"

                "XDG_SESSION_TYPE, wayland"
                "XDG_MENU_PREFIX, plasma-"
                "ELECTRON_OZONE_PLATFORM_HINT, auto"

                "QT_QPA_PLATFORM, wayland"
                "QT_QPA_PLATFORMTHEME, kde"
                "QT_STYLE_OVERRIDE, Breeze"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"

                "PATH, $PATH:$HOME/.setup/home-manager/hyprland/scripts"

                "XCURSOR_THEME, Sweet-cursors"
                "XCURSOR_SIZE, 24"
            ];

            monitor = [
                "HDMI-A-2, 1920x1080@144, 0x0, 1"
                "DP-1, 3840x2160@60, 1920x0, 2"
            ];

            input = {
                follow_mouse = 1;
                kb_layout = lib.concatStringsSep ", " keyboardLayout.layouts;
                kb_options = lib.concatStringsSep ", " keyboardLayout.options;
            };

            xwayland = {
                force_zero_scaling = true;
            };

            exec-once = [
                "kstart plasmashell"
                "ckb-next"
            ];

            misc = {
                middle_click_paste = false;
            };
        };
    };
}
