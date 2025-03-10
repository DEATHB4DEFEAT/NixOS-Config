{
    pkgs,
    ...
}:

{
    imports = [
        ./hyprlock/.
        ./plugins/hypr-dynamic-cursors.nix
        ./plugins/split-monitor-workspaces.nix
        ./decoration.nix
        ./display.nix
        ./input.nix
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

        settings = let
            inherit (import ./variables.nix)
                # keyboardLayout
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

            exec-once = [
                "kstart plasmashell"
                "hyprlock"
                "ckb-next"
            ];

            dwindle = {
                pseudotile = true;
                preserve_split = true;
            };

            misc = {
                force_default_wallpaper = 0;
                vfr = true;
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
