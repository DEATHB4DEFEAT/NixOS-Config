{
    lib,
    pkgs,
    ...
}:

{
    imports = [
        ./keybinds.nix
        ./mousebinds.nix
        ./plugins/hypr-dynamic-cursors.nix
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
                repeat_rate = 25;
                repeat_delay = 250;
            };

            xwayland = {
                force_zero_scaling = true;
            };

            exec-once = [
                "kstart plasmashell"
                "ckb-next"
            ];

            general = {
                gaps_in = 5;
                gaps_out = 10;
                border_size = 2;
                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                layout = "dwindle";
            };

            decoration = {
                rounding = 8;

                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;
                    vibrancy = 0.1696;
                    new_optimizations = true;
                };

                shadow = {
                    enabled = true;
                    range = 4;
                    render_power = 3;
                    color = "rgba(1a1a1aee)";
                };
            };

            animations = {
                enabled = true;

                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                animation = [
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
                ];
            };

            dwindle = {
                pseudotile = true;
                preserve_split = true;
            };

            misc = {
                middle_click_paste = false;
                force_default_wallpaper = 0;
            };

            windowrulev2 = [
                "suppressevent maximize,class:.*"

                "stayfocused, title:^()$, class:^(steam)$"

                # Fix plasmashell popups
                "float, class:^(org.kde.plasmashell)$"
                "move onscreen cursor -50% -1%, class:^(org.kde.plasmashell)$"

                # Fix odd behaviors in IntelliJ IDEs
                #? Fix splash screen showing in weird places and prevent annoying focus takeovers
                "center, class:^(jetbrains-.*)$, title:^(splash)$, floating:1"
                "nofocus, class:^(jetbrains-.*)$, title:^(splash)$, floating:1"
                "noborder, class:^(jetbrains-.*)$, title:^(splash)$, floating:1"
                #? Center popups/find windows
                "center, class:^(jetbrains-.*)$, title:^( )$, floating:1"
                "stayfocused, class:^(jetbrains-.*)$, title:^( )$, floating:1"
                "noborder, class:^(jetbrains-.*)$, title:^( )$, floating:1"
                #? Disable window flicker when autocomplete or tooltips appear
                "nofocus, class:^(jetbrains-.*)$, title:^(win.*)$, floating:1"
            ];
        };
    };
}
