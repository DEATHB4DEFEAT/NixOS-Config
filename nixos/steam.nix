{
    pkgs,
    lib,
    ...
}:

{
    hardware.steam-hardware.enable = true;

    programs = lib.mkDefault {
        steam = {
            enable = true;
            package = pkgs.steam.override {
                extraLibraries = p: with p; [
                    libunwind
                    pipewire
                    openal
                    # For Space Station 14
                    openssl
                    fluidsynth
                    soundfont-fluid
                ];
            };
            # gamescopeSession.enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
        };

        # gamescope = {
        # 	enable = true;
        # 	capSysNice = true;
        # 	args = [
        # 		"--expose-wayland"
        # 	];
        # };

        gamemode = {
            enable = true;

            settings = {
                general = {
                    softrealtime = true;
                };
            };
        };

        dconf.enable = true;
    };


    environment.systemPackages = with pkgs; [
        fluidsynth
        steamPackages.steamcmd
        steam-tui
        gamescope
        bubblewrap
    ];

    environment.sessionVariables = {
        # Steam needs this to find Proton-GE
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        STEAM_FORCE_DESKTOPUI_SCALING = "2";
    };
}
