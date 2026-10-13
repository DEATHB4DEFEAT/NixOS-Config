{ pkgs, inputs, ... }:

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
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        systemd.enable = false;
        xwayland.enable = true;
        configType = "lua";
        extraConfig = builtins.readFile ./hyprland.lua;
    };

    stylix.targets.hyprland.enable = false;
}
