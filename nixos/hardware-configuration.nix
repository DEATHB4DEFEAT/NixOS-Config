{
    config,
    lib,
    modulesPath,
    ...
}:

{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        # ./plymouth.nix
    ];

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
            options = [
                "noatime"
            ];
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
