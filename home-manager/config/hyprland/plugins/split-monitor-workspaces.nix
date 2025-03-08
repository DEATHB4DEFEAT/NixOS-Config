{
    pkgs,
    ...
}:

{
    wayland.windowManager.hyprland = {
        plugins = [
            pkgs.death.split-monitor-workspaces
        ];
        settings = let
            inherit (import ../variables.nix)
                workspaces
            ;
        in {
            plugin = {
                split-monitor-workspaces = {
                    count = workspaces;
                    keep_focused = true;
                };
            };
        };
    };
}
