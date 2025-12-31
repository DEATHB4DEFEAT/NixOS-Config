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
        settings = {
            "plugin:dynamic-cursors" = {
                enabled = true;
                mode = "stretch"; # tilt, rotate, stretch, none
                threshold = 2;

                stretch = {
                    limit = 3000;

                    function = "quadratic"; # linear, quadratic, negative_quadratic
                };

                shake = {
                    enabled = false;
                };
            };
        };
    };
}
