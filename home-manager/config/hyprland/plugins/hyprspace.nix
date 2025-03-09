{
    pkgs,
    inputs,
    ...
}:

{
    wayland.windowManager.hyprland = {
        plugins = [
            inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
        ];
        settings = let
            inherit (import ../variables.nix)

            ;
        in {
            bind = [
                "SUPER, D, exec, hyprctl dispatch overview:toggle"
            ];

            plugin.overview = {
                workspaceActiveBorder = "rgba(33ccffee)";
                workspaceInactiveBorder = "rgba(595959aa)";

                affectStrut = false;
                centerAligned = true;
                overrideGaps = false;

                showNewWorkspace = false;
            };
        };
    };
}
