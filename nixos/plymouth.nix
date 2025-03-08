{
    pkgs,
    config,
}:

{
    boot = {
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

            extraConfig = ''
                DeviceScale=2
            '';
        };

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

        # Hide the OS choice for bootloaders
        # It's still possible to open the bootloader list by pressing any key
        loader.timeout = 0;
    };
}
