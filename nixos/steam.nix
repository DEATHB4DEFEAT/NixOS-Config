{
    pkgs,
    lib,
    ...
}:

{
    programs = lib.mkDefault {
        steam = {
            enable = true;
            package = pkgs.steam-millennium
            # .override {
            #     extraLibraries = p: with p; [
            #         libunwind
            #         pipewire
            #         openal
            #         # For Space Station 14
            #         openssl
            #         fluidsynth
            #         soundfont-fluid
            #     ];
            # }
            ;
            extraCompatPackages = with pkgs; [
                proton-ge-bin
            ];
            gamescopeSession = {
                # enable = true;
                args = [
                    "-W 3840"
                    "-H 2160"
                    "-r 60"
                    "-O DP-1"
                ];
            };

            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
        };

        # gamescope -- %command%
        gamescope = {
        	# enable = true;
        	capSysNice = true;
        	args = [
                "-W 3840"
                "-H 2160"
                "-r 60"
                "-O DP-1"
        	];
        };

        gamemode = {
            enable = true;

            settings = {
                general = {
                    softrealtime = true;
                    renice = 10;
                };
                gpu = {
                    apply_gpu_optimisations = "accept-responsibility";
                    amd_performance_level = "high";
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
        # gamescope
        bubblewrap
    ];

    environment.sessionVariables = {
        STEAM_FORCE_DESKTOPUI_SCALING = "2";
    };
}
