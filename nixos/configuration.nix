{
    pkgs,
    inputs,
    lib,
    ...
}:

{
    imports = [
        ../_secrets/.

        ./bluetooth.nix
        # ./ethernet-out.nix
        ./hardware-configuration.nix

        # ./jovian.nix
        # ./podman.nix
        ./steam.nix

        # ./ascii-workaround.nix
    ];


    systemd.enableEmergencyMode = false; # Causes issues when fstab fails to mount anything, annoying
    boot = {
        loader = {
            # systemd-boot.enable = true;
            grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                useOSProber = true;
                theme = ./grub-themes/HyperFluent-NixOS;
            };
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };
        };

        kernel.sysctl = {
            "vm.max_map_count" = 2147483642;
        };

        kernelPackages = pkgs.linuxPackages_zen;
    };

    security.rtkit.enable = true;


    networking = {
        hostName = "DTLinix";
        hosts = {
            "10.0.0.85" = [ "jellyfin.simplemodbot.tk" ];
        };
    };
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    networking.networkmanager.enable = true;


    time.timeZone = "America/Los_Angeles";

    i18n = {
        supportedLocales = [ "en_US.UTF-8/UTF-8" "en_IE.UTF-8/UTF-8" "en_CA.UTF-8/UTF-8" ];
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_MEASUREMENT = "en_CA.UTF-8";
            LC_TIME = "en_IE.UTF-8";
        };
    };


    #! Don't forget to set a password with ‘passwd’.
    users.users = {
        death = {
            isNormalUser = true;
            description = "Death";
            extraGroups = [
                "networkmanager"
                "wheel"
                "i2c"
                "video"
                "libvirtd"
            ];
            home = "/home/death";
        };
    };


    nixpkgs = {
        config = {
            allowUnfree = true;
            enableParallelBuilding = true;
            permittedInsecurePackages = [
                "freeimage-unstable-2021-11-01"
                "freeimage-3.18.0-unstable-2024-04-18"
            ];
        };

        overlays = [
            (_: pkgs: (import ../pkgs {inherit pkgs lib;}))
        ];
    };

    environment.systemPackages = with pkgs;
    let
        riderScript = pkgs.writeShellScriptBin "rider" "nice -n 10 ${pkgs.steam-run}/bin/steam-run ${pkgs.jetbrains.rider}/bin/rider";
        rider = pkgs.jetbrains.rider.overrideAttrs (oldAttrs: { meta.priority = 10; });
        tetrio = tetrio-desktop.overrideAttrs (oldAttrs: { withTetrioPlus = tetrio-plus; });
        # rustdeskScript = pkgs.writeShellScriptBin "rustdesk" "WAYLAND_DISPLAY=\"\" ${pkgs.rustdesk}/bin/rustdesk";
        # rustdesk = pkgs.rustdesk.overrideAttrs (oldAttrs: { meta.priority = 10; });
        termiusScript = pkgs.writeShellScriptBin "termius-app" "LD_LIBRARY_PATH=\"${pkgs.lib.makeLibraryPath [ pkgs.libglvnd ]}\" ${pkgs.termius}/bin/termius-app";
        termius = pkgs.termius.overrideAttrs (oldAttrs: { meta.priority = 10; });
    in
    [
        nh
        vscode
        rider riderScript
        firefox
        wl-clipboard
        xsel
        ntfs3g
        ntfsprogs
        # ckb-next
        kdePackages.filelight
        kdePackages.partitionmanager
        # sshfs
        hyfetch
        fastfetch
        linux-wifi-hotspot
        xorg.xkbcomp
        mpv
        obsidian
        krita
        # manix
        qpwgraph
        easyeffects
        thunderbird
        prismlauncher
        qemu
        handbrake
        ffmpeg-full
        appimage-run
        linthesia
        neothesia
        element-desktop
        aseprite-unfree
        heroic
        bat
        btop
        fd
        eza
        ripgrep
        zoxide
        # fcp
        sqlitebrowser
        # piper-tts
        tetrio
        # rustdesk #rustdeskScript # https://nixpk.gs/pr-tracker.html?pr=390171
        inkscape-with-extensions
        inkscape-extensions.hexmap
        gimp
        nixd
        termius termiusScript
        desktop-file-utils
        # qmk
        # via
        nix-prefetch-github
        # death.godot_4_4-beta1
        # trenchbroom
        death.robust-lsp
        blockbench
        kdePackages.yakuake
        vesktop
        dbeaver-bin
        jellyfin-media-player
        chromium
        yt-dlg
        syncplay
        wl-kbptr
        droidcam
        openseeface
        v4l-utils
        kdePackages.kdenlive
        uxplay
        # steam-rom-manager
        libsForQt5.layer-shell-qt
        jq
        clonehero
        unzip
        wget
    ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-extra
        jetbrains-mono
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    # hardware.ckb-next.enable = true;


    services.minecraft-servers = {
        enable = true;
        eula = true;
        user = "root";
        group = "root";
        servers =
            let copyFiles = from: to: (let
                evalDir = (
                    prefix: to: dir: (
                        lib.mapAttrsToList
                        (
                            path: type: (
                                let
                                    diffPath = builtins.replaceStrings ["${prefix}"] [""] "${dir}";
                                    diffPathRemovedDep = builtins.unsafeDiscardStringContext diffPath;
                                in (
                                    if (type == "directory")
                                    then (evalDir prefix to "${prefix}${diffPath}/${path}")
                                    else {
                                        "${to}${diffPathRemovedDep}/${path}" = "${prefix}${diffPath}/${path}";
                                    }
                                )
                            )
                        )
                        (builtins.readDir dir)
                    )
                );
                in (
                    lib.mergeAttrsList (lib.flatten (evalDir from to from))
                )
            );
            in {
                tests = {
                    enable = true;
                    autoStart = false;
                    openFirewall = true;
                    package = pkgs.fabricServers.fabric-1_20_1;
                    jvmOpts = "-Xms6144M -Xmx8192M";
                    serverProperties = {
                        server-port = 25566;
                        difficulty = "hard";
                        gamemode = "survival";
                        max-players = 8;
                        view-distance = 24;
                        simulation-distance = 16;
                        motd = "New Origins";
                        allow-flight = true;
                        online-mode = false;
                    };
                };

                # aged =
                #     let modpack = pkgs.fetchModrinthModpack {
                #         # url = "https://cdn.modrinth.com/data/i4XHCd7Q/versions/7BgHWBWr/Aged.mrpack";
                #         # hash = "2ngz4lm4fdnxhzqr7hxa3989a23x7dgmng9ybjzas39c76h9mcq42hw7bks0dxpvz40i9mg28fnnkiswlcvwbk2hx6qb14wk1x2v4nz";
                #         mrpackFile = ./Aged.mrpack;
                #         removeProjectIDs = [
                #             "uXXizFIs"
                #             "uCdwusMi"
                #         ];
                #     };
                # in {
                #     enable = true;
                #     autoStart = false;
                #     openFirewall = true;
                #     package = pkgs.fabricServers.fabric-1_20_1;
                #     jvmOpts = "-Xms6144M -Xmx8192M";
                #     serverProperties = {
                #         server-port = 25567;
                #         difficulty = "hard";
                #         gamemode = "survival";
                #         max-players = 8;
                #         view-distance = 24;
                #         simulation-distance = 16;
                #         motd = "Aged";
                #         allow-flight = true;
                #         online-mode = false;
                #     };
                #     symlinks = {
                #         mods = "${modpack}/mods";
                #     };
                #     files = (copyFiles "${modpack}/config" "config");
                #     #     // (copyFiles "${modpack}/mods" "mods");
                # };

                # stoneblock3 =
                #     let modpack = pkgs.fetchModrinthModpack {
                #         mrpackFile = ./StoneBlock3.mrpack;
                #     };
                # in {
                #     enable = true;
                #     autoStart = false;
                #     openFirewall = true;
                #     package = pkgs.forgeServers.forge-1_18_2.override {
                #         loaderVersion = "40.2.14";
                #         jre_headless = pkgs.jdk17;
                #     };
                #     jvmOpts = "-Xms6144M -Xmx8192M";
                #     serverProperties = {
                #         server-port = 25568;
                #         difficulty = "hard";
                #         gamemode = "survival";
                #         max-players = 8;
                #         view-distance = 24;
                #         simulation-distance = 16;
                #         motd = "StoneBlock 3";
                #         allow-flight = true;
                #         online-mode = false;
                #     };
                #     symlinks = {
                #         mods = "${modpack}/mods";
                #     };
                #     files = (copyFiles "${modpack}/config" "config");
                # };
            };
    };


    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 25565 24454 7100 7000 7001 ];
    networking.firewall.allowedUDPPorts = [ 25565 24454 7011 6001 6000 ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
            enable = true;
            userServices = true;
        };
        openFirewall = true;
    };
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?

    nix = {
        settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];

            substituters = [
                "https://hyprland.cachix.org"
            ];
            trusted-public-keys = [
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            ];
        };

        optimise = {
            automatic = true;
            dates = [ "03:45 "];
        };

        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
        };
    };


    console.useXkbConfig = true;
    services = {
        xserver = {
            enable = true;
            xkb = {
                layout = "us,custom";
                options = "grp:shifts_toggle,grp_led:scroll";

                extraLayouts = {
                    custom = {
                        description = "CarpalX's QGMLWY layout.";
                        languages = [ "eng" ];
                        symbolsFile = /home/death/.setup/keyboard/xkb/symbols/qgmlwy.xkb;
                        keycodesFile = /home/death/.setup/keyboard/xkb/keycodes/1024.xkb;
                    };
                };
            };
        };

        desktopManager.plasma6.enable = true;

        displayManager = {
            defaultSession = "hyprland-uwsm";
            sddm = {
                enable = true;
                wayland = {
                    enable = true;
                    compositorCommand = "${pkgs.hyprland}/bin/hyprland -c ${pkgs.writeTextFile { name = "sddm-hyprland"; destination = "/sddm-hyprland.conf"; text = builtins.readFile ./sddm-hyprland.conf; } }/sddm-hyprland.conf";
                };
                settings = {
                    General = {
                        GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
                    };
                    Theme = {
                        CursorTheme = "Sweet-cursors";
                        CursorSize = 24;
                    };
                };
            };
            autoLogin = {
                enable = true;
                user = "death";
            };
        };

        kanata =
            let
                zippy = builtins.path {
                    path = ../keyboard/kanata/zippy;
                    name = "zippy";
                };
            in {
                enable = true;
                package = pkgs.kanata;
                keyboards.default = {
                    config = (builtins.replaceStrings ["zippy.txt"] ["${(builtins.replaceStrings ["/nix/store/"] [""] zippy)}"] (builtins.readFile ../keyboard/kanata/death.kbd));
                    extraDefCfg = (builtins.readFile ../keyboard/kanata/death-defcfg);
                    devices = [ ];
                };
            };

        ollama = {
            enable = false;
            acceleration = "rocm";
            # environmentVariables = {
            #   HSA_OVERRIDE_GFX_VERSION = "11.0.0";
            # };
            rocmOverrideGfx = "11.0.0";
        };

        udev.packages = with pkgs; [
            qmk-udev-rules
            via
        ];

        journald = {
            extraConfig = "SystemMaxUse=100M";
        };
    };
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
    ];

    programs.hyprland = {
        enable = true;
        withUWSM  = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
        ];
    };

    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        LSP_SERVER_PATH = "${pkgs.death.robust-lsp}/bin/robust-lsp";
        GSETTINGS_SCHEMA_DIR="${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
        PULSE_LATENCY_MSEC = "30";

        ACCESSIBILITY_ENABLED = "1";
        GTK_MODULES = "gail:atk-bridge";
        OOO_FORCE_DESKTOP = "gnome";
        GNOME_ACCESSIBILITY = "1";
        QT_ACCESSIBILITY = "1";
        QT_LINUX_ACCESSIBILITY_ALWAYS_ON = "1";
    };


    boot.binfmt.registrations.appimage = {
        wrapInterpreterInShell = false;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
        magicOrExtension = ''\x7fELF....AI\x02'';
    };


    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
    };

    systemd.user.services = {
        pipewire.serviceConfig = { Nice = -10; };
        pipewire-pulse.serviceConfig = { Nice = -10; };
        mpris-proxy = {
            description = "Mpris proxy";
            after = [ "network.target" "sound.target" ];
            wantedBy = [ "default.target" ];
            serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        };
    };


    programs = {
        bash.blesh.enable = true;
        kdeconnect.enable = true;
        nix-ld = {
            enable = true;
            libraries = with pkgs; [
                libunwind
                pipewire
                openal
                openssl
                fluidsynth
                soundfont-fluid
                xorg.libSM
                icu
                fontconfig
                xorg.libX11
                xorg.libICE
                xdotool
                gtk3
                gdk-pixbuf
                webkitgtk_4_1
                cairo
                libsoup_3
                glib
                alsa-lib
                wayland
                libxkbcommon
                coreutils
                file
                lsb-release
                pciutils
                glibc_multi.bin
                xz
                zenity
            ]; # ++ config.environment.systemPackages;
        };

        obs-studio = {
            enable = true;
            # enableVirtualCamera = true; # Done manually in hardware config
            plugins = with pkgs.obs-studio-plugins; [
                droidcam-obs
                waveform
            ];
        };

        gnupg.agent = {
            enable = true;
        };
    };


    systemd.services = {
        # "Disable" middle mouse paste
        # disable-primary-select = {
        #     description = "Disable primary selection paste";
        #     wantedBy = [ "default.target" ];

        #     script = ''
        #         if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        #             echo "Wayland"
        #             wl-paste -p --watch wl-copy -p < /dev/null  # Usually works.
        #             # wl-paste -p --watch wl-copy -cp  # 100% Effective, may cause issues selecting text in GTK applications.
        #         fi

        #         while [ "$XDG_SESSION_TYPE" == "x11" ]; do
        #             echo "X11"
        #             xsel -fin </dev/null  # 100% Effective, May cause issues selecting text in GTK applications.
        #         done

        #         echo "Done - you should never see this"
        #     '';
        # };

        # Boot sounds
        # startup-sound = {
        #     enable = true;
        #     description = "Startup Sound";
        #     wants = [ "sound.target" ];
        #     after = [ "sound.target" ];
        #     wantedBy = [ "multi-user.target" ];
        #     serviceConfig = {
        #         Type = "oneshot";
        #         ExecStart = "${pkgs.alsa-utils}/bin/aplay -c 2 -D hdmi:CARD=HDMI,DEV=3 ${../resources/audio/startup.wav}";
        #         RemainAfterExit = false;
        #     };
        # };
        # shutdown-sound = {
        #     enable = true;
        #     description = "Shutdown Sound";
        #     wants = [ "sound.target" ];
        #     after = [ "final.target" ];
        #     wantedBy = [ "final.target" ];
        #     serviceConfig = {
        #         Type = "oneshot";
        #         ExecStart = "${pkgs.alsa-utils}/bin/aplay -c 2 -D hdmi:CARD=HDMI,DEV=3 ${../resources/audio/shutdown.wav}";
        #         RemainAfterExit = false;
        #     };
        # };
    };

    system.activationScripts = {
        hyprpanel = ''
            symlink() {
                local src="$1"
                local dest="$2"
                local user="$3"
                [[ -e "$src" ]] && {
                    [[ -e $dest ]] && {
                        echo "****** OK: $dest exists"
                    } || {
                        ln -s "$src" "$dest" || {
                            echo "****** ERROR: could not symlink $src to $dest"
                        }
                        echo "****** CHANGED: $dest updated"
                    }
                } || {
                    echo "****** ERROR: source $src does not exist"
                }
            }

            symlink /home/death/.setup/home-manager/config/hyprland/hyprpanel \
                /home/death/.config/hyprpanel
            symlink /home/death/.setup/home-manager/config/hyprland/rofi \
                /home/death/.config/rofi
        '';
    };
}
