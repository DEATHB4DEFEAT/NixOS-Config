{
    pkgs,
    ...
}:

{
    programs.rofi = let
        inherit (import ./variables.nix)
            terminal
        ;
    in
    {
        enable = true;
        package = pkgs.rofi-wayland;
        location = "top";
        terminal = terminal;

        plugins = with pkgs; [
            rofi-calc
            rofi-emoji-wayland
            rofi-pulse-select
        ];

        extraConfig = {
            modi = "window,run,drun,ssh,calc,emoji";
        };
    };

    wayland.windowManager.hyprland.settings = {

    };
}
