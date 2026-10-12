{
    pkgs,
    inputs,
    ...
}:

{
    wayland.windowManager.hyprland = {
        plugins = [
            inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
        ];
    };
}
