# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
    pkgs,
    lib,
    ...
}:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./steam.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
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

    # Configure keymap in X11
    services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
    };


    # Define a user account. Don't forget to set a password with ‘passwd’.
    # Normal user account
    users.users.death = {
        isNormalUser = true;
        description = "Death";
        extraGroups = [
            "networkmanager"
            "wheel"
        ];
        home = "/home/death";
    };

    # Extra account, used for logging into KDE at the same time as death is in Hyprland
    users.users.keath = {
        isNormalUser = true;
        description = "Keath";
        extraGroups = [
            "networkmanager"
            "wheel"
        ];
        home = "/home/keath"; # This is a symlink to /home/death :)
        createHome = false; # This is handled by the systemd service below
    };


    users.groups.deaths.members = [ "death" "keath" ];


    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        firefox
    ];
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        jetbrains-mono
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

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

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    programs.hyprland.enable = true;
    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };


    services.flatpak.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    hardware.pulseaudio.enable = lib.mkForce false;

    programs.gnupg.agent = {
        enable = true;
    };

    xdg.portal.enable = true;


    # Run a script to fix permissions on the home directory
    systemd.services.fix-permissions = {
        description = "Fix permissions on home directory";
        wantedBy = [ "default.target" ];
        script = ''
            ln -s /home/death /home/keath || true # Make sure keath's home directory is a symlink to death's, ignore failure since it's probably already a symlink
            chown -R death:deaths /home/death # Give death and his group ownership of his home directory
            chmod -R g=u /home/death # Give the group whatever permissions death has
            systemctl start home-manager-keath # Fails during reconfigure after changing home-manager things, but works fine when started manually
        '';
    };
}
