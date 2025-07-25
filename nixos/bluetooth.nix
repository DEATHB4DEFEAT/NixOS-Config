{
    config,
    ...
}:

{
    # Enable Bluetooth
    services.blueman.enable = true;
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
            experimental = true; # show battery

            # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
            # for pairing bluetooth controller
            Privacy = "device";
            JustWorksRepairing = "always";
            Class = "0x000100";
            FastConnectable = true;
        };
    };

    hardware.xone.enable = true;

    boot = {
        extraModulePackages = with config.boot.kernelPackages; [ xone ];
        extraModprobeConfig = ''
            options bluetooth disable_ertm=Y
        '';
    };
}
