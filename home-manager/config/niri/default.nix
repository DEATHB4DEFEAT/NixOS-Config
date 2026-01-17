{
    pkgs,
    ...
}:

{
    imports = [

    ];

    home = {
        packages = with pkgs; [
            death.niri-settings
        ];
    };
}
