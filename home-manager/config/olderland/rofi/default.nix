{
    pkgs,
    ...
}:

{
    home.packages = with pkgs; [
        rofi
    ];

    wayland.windowManager.hyprland.settings = {
        bind = [
            "SUPER, Space, exec, launcher_t6"
        ];
    };
}
