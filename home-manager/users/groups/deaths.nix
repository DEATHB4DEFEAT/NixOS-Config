{
    pkgs,
    ...
}:

{
    home.stateVersion = "23.11";
    home.packages = with pkgs; [
        vscode
        nh
        nixd
        vesktop
        termius
        youtube-music
        obsidian
        obs-studio
        mpv
        krita
    ];
    home.sessionVariables = {
        FLAKE = "/home/death/setup";
    };


    imports = [
        ../../apps/foot.nix
        ../../apps/shell.nix

        ../../hyprland/.
        ../../hyprland/keybinds.nix
        ../../hyprland/mousebinds.nix

        ../../system/git.nix
        ../../system/gpg.nix
    ];
}