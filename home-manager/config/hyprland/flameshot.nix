{
    pkgs,
    ...
}:

{
    home.packages = with pkgs; [
        grim
        (flameshot.override (old: {
            enableWlrSupport = true;
        }))
    ];

    wayland.windowManager.hyprland = {
        settings = let
            inherit (import ./variables.nix)

            ;
        in
        {
            bind = [
                ", Print, exec, XDG_CURRENT_DESKTOP=sway flameshot gui -c"
            ];

            windowrulev2 = [
                "noanim, class:^(flameshot)$"
                "float, class:^(flameshot)$"
                "move 0 0, class:^(flameshot)$"
                "pin, class:^(flameshot)$"
                "monitor 1, class:^(flameshot)$"
            ];
        };
    };
}
