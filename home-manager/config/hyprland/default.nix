{
    pkgs,
    inputs,
    ...
}:

{
    imports = [
        ./hyprlock
        ./hyprpanel
    ];

    home.packages = with pkgs; [
        playerctl
        brightnessctl
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qtstyleplugin-kvantum
        kdePackages.qt6ct
        (catppuccin-kvantum.override {
            accent = "mauve";
            variant = "mocha";
        })
        hyprshot
        hyprshutdown
        rofi
        pipewire.jack
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.enable = false;
        xwayland.enable = true;

        plugins = [
            inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
            # inputs.hyprland-scroll-overview.packages.${pkgs.stdenv.hostPlatform.system}.scrolloverview
        ];
        configType = "lua";
        extraConfig = builtins.readFile ./hyprland.lua;
    };

    xdg.configFile."xdg-desktop-portal/Hyprland-portals.conf".text = ''
        [preferred]
        default = hyprland;gtk
        org.freedesktop.impl.portal.FileChooser = kde
    '';
}
