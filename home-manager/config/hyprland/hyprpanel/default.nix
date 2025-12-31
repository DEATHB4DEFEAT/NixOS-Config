{
    pkgs,
    config,
    inputs,
    ...
}:

{
    home.packages = [
        inputs.hyprpanel.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    wayland.windowManager.hyprland.settings.exec-once = [
        "hyprpanel"
    ];
}
