{
    pkgs,
    ...
}:

{
    stylix = {
        enable = true;

        targets = {
            grub.enable = false;
        };

        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        image = ../resources/images/wallpapers/wall0.png;
        # polarity = "dark";

        fonts = {
            sizes = {
                applications = 12;
                desktop = 10;
                popups = 14;
                terminal = 16;
            };
            serif = {
                package = pkgs.jetbrains-mono;
                name = "JetBrains Mono";
            };
            sansSerif = {
                package = pkgs.jetbrains-mono;
                name = "JetBrains Mono";
            };
            monospace = {
                package = pkgs.jetbrains-mono;
                name = "JetBrains Mono SemiBold";
            };
            emoji = {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
            };
        };

        cursor = {
            name = "catppuccin-macchiato-mauve-cursors";
            package = pkgs.catppuccin-cursors.macchiatoMauve;
            size = 24;
        };

        icons = {
            enable = true;
            dark = "candy-icons";
            light = "candy-icons";
            package = pkgs.candy-icons;
        };
    };
}
