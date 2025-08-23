{
    ...
}:

{
    stylix = {
        targets = {
            # hyprland.enable = false;
            hyprlock.enable = false;
            firefox = {
                profileNames = [ "default" ];
                colorTheme.enable = true;
            };
        };
    };

    home.activation = {
        stylix = ''
            rm /home/death/.config/qt5ct/qt5ct.conf
            rm /home/death/.config/qt5ct/qt5ct.conf.bak
            rm /home/death/.config/qt6ct/qt6ct.conf
            rm /home/death/.config/qt6ct/qt6ct.conf.bak
            cp /home/death/.setup/home-manager/config/apps/config/qtct.conf \
                /home/death/.config/qt5ct/qt5ct.conf
            cp /home/death/.setup/home-manager/config/apps/config/qtct.conf \
                /home/death/.config/qt6ct/qt6ct.conf
        '';
    };
}
