{
    pkgs,
    inputs,
    ...
}:

{
    home.packages = [
        inputs.hyprpanel.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    wayland.windowManager.hyprland.settings = {
        # exec-once = [
        #     "hyprpanel"
        # ];
        bind = [
            "SUPER, bracketright, exec, pkill hyprpanel || hyprpanel" # Not ideal but works, I don't need it responsive enough to care
        ];
    };
}
