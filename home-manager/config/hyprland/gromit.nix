{
    pkgs,
    ...
}:

{
    home.packages = with pkgs; [
        gromit-mpx
    ];

    wayland.windowManager.hyprland.settings = {
        workspace = [
            "special:gromit, gapsin:0, gapsout:0, rounding:false, shadow:false, on-created-empty:gromit-mpx -a"
        ];

        windowrule = [
            "noblur, ^(Gromit-mpx)$"
            "opacity 1 override, 1 override, ^(Gromit-mpx)$"
        ];

        bind = [
            "SUPER, F9, togglespecialworkspace, gromit"
            "SUPER SHIFT, F9, exec, gromit-mpx --clear"
            "SUPER, F8, exec, gromit-mpx --undo"
            "SUPER SHIFT, F8, exec, gromit-mpx --redo"
        ];
    };
}
