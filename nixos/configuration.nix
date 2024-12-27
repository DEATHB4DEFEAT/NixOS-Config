{
    pkgs,
    lib,
    ...
}:

{
    imports = [
        ../_secrets/.

        ./hardware-configuration.nix

        ./podman.nix
        ./steam.nix

        # ./ascii-workaround.nix
    ];


    systemd.enableEmergencyMode = false; # Causes issues when fstab fails to mount anything, annoying
    boot = {
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        kernel.sysctl = {
            "vm.max_map_count" = 2147483642;
        };

        kernelPackages = pkgs.linuxPackages_zen;
    };


    networking.hostName = "DTLinix"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;


    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };


    # Don't forget to set a password with ‘passwd’.
    users.users = {
        death = {
            isNormalUser = true;
            description = "Death";
            extraGroups = [
                "networkmanager"
                "wheel"
                "i2c"
            ];
            home = "/home/death";
        };
    };


    nixpkgs = {
        config = {
            allowUnfree = true;
            enableParallelBuilding = true;
        };
    };

    environment.systemPackages = with pkgs;
    let
        riderScript = pkgs.writeShellScriptBin "rider" "${pkgs.steam-run}/bin/steam-run ${pkgs.jetbrains.rider}/bin/rider";
        rider = pkgs.jetbrains.rider.overrideAttrs (oldAttrs: { meta.priority = 10; });
        tetrio = tetrio-desktop.overrideAttrs (oldAttrs: { withTetrioPlus = tetrio-plus; });
        rustdeskScript = pkgs.writeShellScriptBin "rustdesk" "WAYLAND_DISPLAY=\"\" ${pkgs.rustdesk}/bin/rustdesk";
        rustdesk = pkgs.rustdesk.overrideAttrs (oldAttrs: { meta.priority = 10; });
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
        ckb-next
        kdePackages.filelight
        kdePackages.partitionmanager
        kdePackages.sddm-kcm
        sshfs
        hyfetch
        fastfetch
        linux-wifi-hotspot
        xorg.xkbcomp
        mpv
        obsidian
        obs-studio
        krita
        manix
        qpwgraph
        easyeffects
        distrobox
        thunderbird
        prismlauncher
        kanata
        qemu
        handbrake
        ffmpeg-full
        appimage-run
        linthesia
        neothesia
        element-desktop-wayland
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
        piper-tts
        tetrio
        rustdesk rustdeskScript
        inkscape-with-extensions
        inkscape-extensions.hexmap
        gimp-with-plugins
        gimpPlugins.bimp
        gimpPlugins.texturize
        nixd
    ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-extra
        jetbrains-mono
    ];

    hardware.ckb-next.enable = true;


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

                aged =
                    let modpack = pkgs.fetchModrinthModpack {
                        # url = "https://cdn.modrinth.com/data/i4XHCd7Q/versions/7BgHWBWr/Aged.mrpack";
                        # hash = "2ngz4lm4fdnxhzqr7hxa3989a23x7dgmng9ybjzas39c76h9mcq42hw7bks0dxpvz40i9mg28fnnkiswlcvwbk2hx6qb14wk1x2v4nz";
                        mrpackFile = ./Aged.mrpack;
                        removeProjectIDs = [
                            "uXXizFIs"
                            "uCdwusMi"
                        ];
                    };
                in {
                    enable = true;
                    autoStart = false;
                    openFirewall = true;
                    package = pkgs.fabricServers.fabric-1_20_1;
                    jvmOpts = "-Xms6144M -Xmx8192M";
                    serverProperties = {
                        server-port = 25567;
                        difficulty = "hard";
                        gamemode = "survival";
                        max-players = 8;
                        view-distance = 24;
                        simulation-distance = 16;
                        motd = "Aged";
                        allow-flight = true;
                        online-mode = false;
                    };
                    symlinks = {
                        mods = "${modpack}/mods";
                    };
                    files = (copyFiles "${modpack}/config" "config");
                    #     // (copyFiles "${modpack}/mods" "mods");
                };

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
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];


    console.useXkbConfig = true;
    services = {
        xserver = {
            enable = true;
            xkb = {
                layout = "us,custom";
                options = "grp:alts_toggle,grp_led:scroll";

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

        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;

        kanata = {
            enable = true;
            keyboards.default = {
                #TODO: Hot reloading doesn't work and using includes never works
                config = (builtins.readFile /home/death/.setup/keyboard/kanata/death.kbd);
                extraDefCfg = (builtins.readFile /home/death/.setup/keyboard/kanata/death-defcfg);
                devices = [ ];
            };
        };

        ollama = {
            enable = true;
            acceleration = "rocm";
            # environmentVariables = {
            #   HSA_OVERRIDE_GFX_VERSION = "11.0.0";
            # };
            rocmOverrideGfx = "11.0.0";
        };
    };
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
    ];

    programs.hyprland.enable = true;
    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };


    boot.binfmt.registrations.appimage = {
        wrapInterpreterInShell = false;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
        magicOrExtension = ''\x7fELF....AI\x02'';
    };


    hardware.pulseaudio.enable = lib.mkForce false;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;

        extraConfig = {
            pipewire.context.properties.default = {
                clock.rate = 48000;
                clock.allowed-rates = [ 48000 ];
                clock.min-quantum = 32;
                clock.quantum = 1024;
                clock.max-quantum = 2048;
            };

            pipewire-pulse = {
                context.modules = [
                    {
                        name = "libpipewire-module-protocol-pulse";
                        args = {
                            pulse = {
                                min = {
                                    req = "32/48000";
                                    quantum = "32/48000";
                                    frag = "32/48000";
                                };

                                default = {
                                    req = "1024/48000";
                                    quantum = "1024/48000";
                                    frag = "1024/48000";
                                };

                                max = {
                                    req = "2048/48000";
                                    quantum = "2048/48000";
                                    frag = "2048/48000";
                                };
                            };
                        };
                    }
                ];

                stream.properties = {
                    node.latency = "1024/48000";
                    resample.quality = 1;
                };
            };
        };
    };

    systemd.user.services = {
        pipewire.serviceConfig = { Nice = -10; };
        pipewire-pulse.serviceConfig = { Nice = -10; };

        # Easy effects
        easyeffects = {
            description = "Easy Effects";
            after = [ "pipewire-pulse.service" ];
            wantedBy = [ "graphical-session.target" ];

            serviceConfig = {
                ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
                Nice = -10;
            };
        };
    };

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true; # Power up the default Bluetooth controller on boot
    };
    services.blueman.enable = true;
    systemd.user.services.mpris-proxy = {
        description = "Mpris proxy";
        after = [ "network.target" "sound.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };


    programs.gnupg.agent = {
        enable = true;
    };

    xdg.portal.enable = true;

    programs = {
        bash.blesh.enable = true;
        kdeconnect.enable = true;
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
    };
}
