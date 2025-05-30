{
    programs.foot = {
        enable = true;
        settings = {
            main = {
                font = "monospace:size=16";
                dpi-aware = "yes";
                gamma-correct-blending = "no";
            };

            scrollback = {
                lines = 10000;
            };

            mouse = {
                hide-when-typing = "yes";
            };

            colors = {
                alpha = 0.0;
                background = "1a1a1a";
                selection-background = "000000";
                selection-foreground = "ffffff";
            };
        };
    };
}
