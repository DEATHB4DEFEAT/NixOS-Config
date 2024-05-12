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
            # For Space Station 14
            openssl
            fluidsynth
            soundfont-fluid
          ];
      };
      #gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
    };

    # gamescope = {
    # 	enable = true;
    # 	capSysNice = true;
    # 	args = [
    # 		"--expose-wayland"
    # 	];
    # };

    dconf.enable = true;
  };


  environment.systemPackages = [
    pkgs.fluidsynth
    pkgs.steamPackages.steamcmd
    pkgs.steam-tui
    pkgs.gamescope
  ];


  environment.sessionVariables = {
    # Steam needs this to find Proton-GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
