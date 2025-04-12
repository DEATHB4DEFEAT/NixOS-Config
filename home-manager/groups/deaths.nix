{
    ...
}:

{
    home = {
        stateVersion = "23.11";

        sessionVariables = {
            FLAKE = "/home/death/.setup";
        };

        keyboard = null;
    };


    imports = [
        ../../_secrets/home-manager/.

        ../config/apps/config/mpv.nix

        ../config/apps/foot.nix
        ../config/apps/shell.nix

        ../config/hyprland/.

        ../config/system/git.nix
        ../config/system/gpg.nix
    ];
}
