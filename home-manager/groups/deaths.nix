{
    pkgs,
    ...
}:

{
    home.stateVersion = "23.11";
    home.packages = with pkgs; [
        vscode
        vscode-extensions.ms-dotnettools.csharp
        nh
        nixd
        vesktop
        termius
        youtube-music
        obsidian
        obs-studio
        mpv
        krita
        jetbrains.rider
    ];

    home.sessionVariables = {
        FLAKE = "/home/death/.setup";
    };


    imports = [
        ../config/apps/foot.nix
        ../config/apps/shell.nix

        ../config/hyprland/.
        ../config/hyprland/keybinds.nix
        ../config/hyprland/mousebinds.nix

        ../config/system/git.nix
        ../config/system/gpg.nix
    ];
}
