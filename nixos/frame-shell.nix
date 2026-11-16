{
    inputs,
    config,
    ...
}:

{
    imports = [
        inputs.frame-shell.nixosModules.host
    ];

    services.frame-shell = {
        enable = true;
        inputUsers = [ "death" ]; # get the headset's keyboard and mouse
        # optional: Steam games from the shell, OpenVR games through the flake's patched xrizer
        steamPackage = config.programs.steam.package;
        settings.openvr-compat-path = "${inputs.frame-shell.packages.x86_64-linux.xrizer}/lib/xrizer";
    };
}
