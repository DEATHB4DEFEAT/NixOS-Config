{
    pkgs,
    ...
}:

{
    home.username = "death";
    home.homeDirectory = "/home/death";
    home.stateVersion = "23.11";
    home.packages = with pkgs; [
        vscode
        nh
        nixd
        vesktop
        termius
    ];
    home.sessionVariables = {
        FLAKE = "/home/death/setup";
    };


    imports = [
        ./apps/foot.nix
        ./apps/shell.nix

        ./hyprland/.
        ./hyprland/keybinds.nix
        ./hyprland/mousebinds.nix

        ./system/git.nix
        ./system/gpg.nix
    ];


    programs = {
        direnv = {
            enable = true;
            enableBashIntegration = true;
            nix-direnv.enable = true;
        };
    };
}
