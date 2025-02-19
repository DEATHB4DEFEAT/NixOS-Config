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
            extraCompatPackages = with pkgs; [
                proton-ge-bin
            ];
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
        STEAM_FORCE_DESKTOPUI_SCALING = "2";
        LD_LIBRARY_PATH = [ "${pkgs.lib.makeLibraryPath [ pkgs.libunwind pkgs.pipewire pkgs.openal ]}" ];
    };
}
