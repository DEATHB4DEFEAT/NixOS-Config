{
    config,
    ...
}:

{
    home = {
        stateVersion = "23.11";

        sessionVariables = {
            NH_FLAKE = "/home/death/.setup";
        };

        keyboard = null;
    };

    xdg.configFile."openxr/1/active_runtime.json".text = ''
        {
            "file_format_version": "1.0.0",
            "runtime": {
                "VALVE_runtime_is_steamvr": true,
                "library_path": "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so",
                "name": "SteamVR"
            }
        }
    '';

    imports = [
        ../../_secrets/home-manager/.

        ../config/apps/config/mpv.nix

        ../config/apps/foot.nix
        ../config/apps/shell.nix
        ../config/apps/typecaptions.nix

        ../config/hyprland/.

        # ../config/niri/.

        ../config/system/git.nix
        ../config/system/gpg.nix
        ../config/system/stylix.nix
        ../config/system/theme.nix
    ];
}
