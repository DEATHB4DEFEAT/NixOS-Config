{
    pkgs,
    config,
    lib,
    modulesPath,
    ...
}:

{
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
        initrd =
        {
            availableKernelModules = [
                "xhci_pci"
                "ahci"
                "nvme"
                "usb_storage"
                "usbhid"
                "sd_mod"
            ];

            kernelModules = [
                "amdgpu"
            ];
        };

        kernelModules = [
            "kvm-amd"
            "v4l2loopback"
        ];

        # Enable "Silent Boot"
        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
        ];

        extraModulePackages = with config.boot.kernelPackages; [
            v4l2loopback
        ];

        extraModprobeConfig = ''
            options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
            options bluetooth disable_ertm=1
        '';

        supportedFilesystems = [
            "btrfs"
            "vfat"
            "ntfs3"
        ];


        plymouth = {
            enable = true;
            logo = ./plymouth.png;

            theme = "rings_2";
            themePackages = with pkgs; [
                ((adi1090x-plymouth-themes.overrideAttrs (oldAttrs: {
                    installPhase = (oldAttrs.installPhase or "")
                        + ''
                            for theme in ${config.boot.plymouth.theme}; do
                            echo 'nixos_image = Image("header-image.png");' >> $out/share/plymouth/themes/$theme/$theme.script
                            echo 'nixos_sprite = Sprite();' >> $out/share/plymouth/themes/$theme/$theme.script
                            echo 'nixos_sprite.SetImage(nixos_image);' >> $out/share/plymouth/themes/$theme/$theme.script
                            echo 'nixos_sprite.SetX(Window.GetX() + (Window.GetWidth() / 2 - nixos_image.GetWidth() / 2));' >> $out/share/plymouth/themes/$theme/$theme.script
                            echo 'nixos_sprite.SetY(Window.GetHeight() - nixos_image.GetHeight() - 50);' >> $out/share/plymouth/themes/$theme/$theme.script
                            done
                        '';
                })).override { selected_themes = [ config.boot.plymouth.theme ]; })

                (runCommand "add-logos" { inherit (config.boot.plymouth) logo theme; } ''
                    mkdir -p $out/share/plymouth/themes/$theme
                    ln -s $logo $out/share/plymouth/themes/$theme/header-image.png
                '')
            ];
        };

        # Hide the OS choice for bootloaders
        # It's still possible to open the bootloader list by pressing any key
        loader.timeout = 0;
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/2c55fee3-4f2b-4cd4-8c25-294f7a580f32";
            fsType = "btrfs";
            options = [
                "subvol=@"
                "compress=zstd:5"
                "noatime"
            ];
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/A425-1CF5";
            fsType = "vfat";
        };
        "/drives/LES" = {
            device = "/dev/disk/by-uuid/12a7a1a2-0bd4-42ee-8fd2-6b2209b33d55";
            fsType = "btrfs";
            options = [
                "compress-force=zstd:5"
                "noatime"
            ];
        };

        "/drives/C" = {
            device = "/dev/disk/by-uuid/2CC2BC65C2BC3544";
            fsType = "ntfs";
        };
        "/drives/D" = {
            device = "/dev/disk/by-uuid/06AEE5082B74F336";
            fsType = "ntfs";
        };
        "/drives/E" = {
            device = "/dev/disk/by-uuid/5644295C6F90F411";
            fsType = "ntfs";
        };

        "/drives/death-share" = {
            device = "//10.0.0.251/death-share";
            fsType = "cifs";
            options =
                let
                    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
                in
                    [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
        };
        "/drives/data" = {
            device = "//10.0.0.85/data";
            fsType = "cifs";
            options =
                let
                    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
                in
                    [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
        };
    };


    swapDevices = [
        {
            device = "/drives/LES/swapfile";
            size = 32 * 1024; # 32GB
        }
    ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    services = {
        xserver.videoDrivers = [ "amdgpu" ]; # "nvidia"
        ddccontrol.enable = true;
    };

    hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        # nvidia = {
        #     modesetting.enable = true;
        #     open = true;
        #     # package = config.boot.kernelPackages.nvidiaPackages.beta;
        # };

        amdgpu.opencl.enable = true;

        graphics = {
            enable = true;
            enable32Bit = true;
        };

        xpadneo.enable = true;
        enableAllFirmware = true;
        enableRedistributableFirmware = true;

        i2c.enable = true;

        keyboard = {
            qmk.enable = true;
        };
    };
}
