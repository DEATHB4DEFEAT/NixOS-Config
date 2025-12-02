{
    pkgs,
    lib,
    ...
}:

{
    gtk = {
        enable = true;
        iconTheme = lib.mkForce {
            name = "candy-icons";
            package = pkgs.candy-icons;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };
    dconf.settings = {
        "org/gnome/desktop/interface" = lib.mkForce {
            color-scheme = "prefer-dark";
            icon-theme = "candy-icons";
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "qtct";
        style = {
            name = "kvantum";
            package = pkgs.kdePackages.breeze;
        };
    };
}
