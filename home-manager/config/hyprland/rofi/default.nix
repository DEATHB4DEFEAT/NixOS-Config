{
    pkgs,
    ...
}:

{
    home.packages = with pkgs; [
        rofi
    ];

    wayland.windowManager.hyprland.settings = {
        binds = [
            "SUPER, Space, exec, launcher_t6"
        ];
    };
}
