{
    pkgs,
    inputs,
    ...
}:

{
    imports = [
        ./hyprlock/.
        ./hyprpanel/.
        # ./plugins/hypr-dynamic-cursors.nix
        # ./plugins/hyprspace.nix
        ./plugins/split-monitor-workspaces.nix
        ./rofi/.
        ./decoration.nix
        ./display.nix
        # ./gromit.nix
        # ./hypridle.nix
        ./input.nix
    ];


    home.packages = with pkgs; [
        playerctl
        brightnessctl
        # Theming
        libsForQt5.qtstyleplugin-kvantum
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
        systemd.enable = false;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;

        settings = let
            inherit (import ./variables.nix)
                plasmashell
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
                # "QT_QPA_PLATFORMTHEME, qt6ct"
                # "QT_STYLE_OVERRIDE, kvantum"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"

                "PATH, $PATH:$HOME/.setup/home-manager/config/hyprland/scripts:$HOME/.setup/home-manager/config/hyprland/rofi/scripts"

                "XCURSOR_THEME, catppuccin-macchiato-mauve-cursors"
                "XCURSOR_SIZE, 24"
            ];

            exec-once = [
                "hyprctl switchxkblayout all 1"
                "hyprlock"
                "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
                "kwalletd6"
                # "ckb-next -b"
                # "nice -n -10 easyeffects --gapplication-service"
                "[workspace 4 silent] sleep 10; ${pkgs.carla}/bin/carla $HOME/.setup/home-manager/config/apps/config/carla.carxp"
                # "[workspace 1 silent] vesktop"
                "[workspace 1 silent] equibop"
                "[workspace special:magic silent] sleep 5; finamp"
            ] ++ (if plasmashell then [
                "kstart plasmashell"
            ] else []);


            general = {
                # layout = "dwindle";
                layout = "scrolling";
            };

            dwindle = {
                pseudotile = true;
                preserve_split = true;
            };

            scrolling = {
                column_width = 0.7;
                # focus_fit_method = 0; # 0 = center, 1 = fit
            };


            misc = {
                force_default_wallpaper = 0;
                # disable_hyprland_logo = true; # No wallpaper
                vfr = true;
                # initial_workspace_tracking = 2;
            };

            workspace = [
                "special:magic, gapsin:10, gapsout:10"
            ];

            windowrule = [
                "stay_focused on, match:title ^()$, match:class ^(steam)$"

                # Fix plasmashell popups kinda
                "float on, match:class ^(org.kde.plasmashell)$"
                "move onscreen cursor -50% -1%, match:class ^(org.kde.plasmashell)$"

                # Fix odd behaviors in IntelliJ IDEs
                #? Fix splash screen showing in weird places and prevent annoying focus takeovers
                "center on, match:class ^(jetbrains-.*)$, match:title ^(splash)$, match:float 1"
                "no_focus on, match:class ^(jetbrains-.*)$, match:title ^(splash)$, match:float 1"
                "border_size 0, match:class ^(jetbrains-.*)$, match:title ^(splash)$, match:float 1"
                #? Center popups/find windows
                "center on, match:class ^(jetbrains-.*)$, match:title ^( )$, match:float 1"
                "stay_focused on, match:class ^(jetbrains-.*)$, match:title ^( )$, match:float 1"
                "border_size 0, match:class ^(jetbrains-.*)$, match:title ^( )$, match:float 1"
                #? Disable window flicker when autocomplete or tooltips appear
                "no_focus on, match:class ^(jetbrains-.*)$, match:title ^(win.*)$, match:float 1"

                # # Open certain apps in the right workspace
                # "workspace 1 silent, match:class ^(discord)$"
                # "workspace 1 silent, match:class ^(vesktop)$"
                # "workspace 1 silent, match:class ^(equibop)$"
                # "workspace 4 silent, match:class ^(carla)$"
                # "workspace special:magic silent, match:class ^(finamp)$"
            ];
        };
    };
}
