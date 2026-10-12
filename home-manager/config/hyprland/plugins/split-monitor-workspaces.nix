{ pkgs, inputs, ... }:

{
    wayland.windowManager.hyprland.plugins = [
        inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
    ];
}
