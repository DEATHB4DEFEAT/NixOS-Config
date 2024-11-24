{
    pkgs,
    lib,
    ...
}:

{
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
            gamescopeSession = {
                enable = true;
                args = [
                    "-W 1920"
                    "-H 1080"
                    "-r 60"
                    "--fullscreen"
                ];
            };

            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
        };

        # gamescope -- %command%
        gamescope = {
        	enable = true;
        	capSysNice = true;
        	args = [
                "-W 1920"
                "-H 1080"
                "-r 60"
                "--fullscreen"
        		# "--expose-wayland"
        	];
        };

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

    hardware.steam-hardware.enable = true;


    environment.systemPackages = with pkgs; [
        fluidsynth
        steamcmd
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
