{
    pkgs,
    config,
    inputs,
    ...
}:

{
    home.packages = [
        inputs.hyprpanel.packages.${pkgs.system}.default
    ];

    wayland.windowManager.hyprland.settings.exec-once = [
        "hyprpanel"
    ];
}
