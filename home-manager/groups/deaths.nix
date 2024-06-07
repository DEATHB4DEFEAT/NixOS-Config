{
    pkgs,
    ...
}:

{
    home = {
        stateVersion = "23.11";

        packages = with pkgs; [
            nixd
            vesktop
            termius
            youtube-music
            freetube
        ];

        sessionVariables = {
            FLAKE = "/home/death/.setup";
        };

        keyboard = null;
    };


    imports = [
        ../../_secrets/home-manager/.

        ../config/apps/foot.nix
        ../config/apps/shell.nix

        ../config/hyprland/.

        ../config/system/git.nix
        ../config/system/gpg.nix
    ];
}
