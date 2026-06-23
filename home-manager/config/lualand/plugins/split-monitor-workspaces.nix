{
    pkgs,
    inputs,
    ...
}:

{
    wayland.windowManager.hyprland = {
        plugins = [
            inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
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

            # bind = [
            #     "SUPER, Y, split-grabroguewindows"
            # ];
        };
    };
}
