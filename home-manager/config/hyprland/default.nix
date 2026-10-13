{
    pkgs,
    ...
}:

{
    imports = [
        ./hyprlock
        ./hyprpanel
        ./plugins/hypr-dynamic-cursors.nix
        ./plugins/split-monitor-workspaces.nix
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
        hyprland-qtutils
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
        configType = "lua";
        extraConfig = builtins.readFile ./hyprland.lua;
    };

    # stylix.targets.hyprland.enable = false;
}
