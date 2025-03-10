{
    pkgs,
    inputs,
    ...
}:

{
    imports = [ inputs.ags.homeManagerModules.default ];

    home = {
        packages = with pkgs; [
            ddcutil
            sassc
            sass
            (python311.withPackages (p: [
                p.material-color-utilities
                p.pywayland
                p.psutil
            ]))
            dunst
            libnotify
        ];
    };

    programs.ags = {
        enable = true;
        package = inputs.ags.packages.${pkgs.system}.ags;
        configDir = ./config/ags;
        extraPackages = with pkgs; [
            gtksourceview
            gtksourceview4
            ollama
            python311Packages.material-color-utilities
            python311Packages.pywayland
            pywal
            sassc
            webkitgtk
            webp-pixbuf-loader
            ydotool
        ];
    };
}
