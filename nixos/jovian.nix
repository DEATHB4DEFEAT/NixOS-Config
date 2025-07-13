{
    inputs,
    ...
}:

{
    # imports = [
    #     "${inputs.jovian-nixos}/modules"
    # ];

    jovian = {
        steam = {
            enable = true;
            autoStart = true;
            user = "death";
            desktopSession = "hyprland-uwsm";
        };
        decky-loader.enable = true;
        devices.steamdeck = {
            enableControllerUdevRules = true;
            enableOsFanControl = true;
        };

        hardware.has.amd.gpu = true;
    };
}
