{ pkgs, ... }:

{
  home.username = "death";
  home.homeDirectory = "/home/death";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    vscode
    nh
    nixd
    vesktop
  ];
  home.sessionVariables = {
    FLAKE = "/home/death/setup";
  };


  services = {
    gpg-agent = {
      pinentryPackage = pkgs.pinentry-curses;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };


  programs = {
    foot = {
      enable = true;
    };

    git = {
      enable = true;
      userEmail = "zachcaffee@outlook.com";
      userName = "DEATHB4DEFEAT";
      signing = {
        key = "62B0D3993D872EBB";
        signByDefault = true;
      };
      extraConfig.init.defaultBranch = "master";
    };
    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = [
          "https://github.com"
          "https://gist.github.com"
        ];
      };
    };

    gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        reconf = "sudo nixos-rebuild switch --flake '/home/death/setup#DTLinix'";
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };


  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, RETURN, exec, foot"
          "$mod, Q, killactive"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let ws =
                let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          )
        );
      bindm = [
        "ALT, mouse:272, movewindow"
        "ALT, mouse:273, resizewindow"
      ];

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];
    };
  };
}
