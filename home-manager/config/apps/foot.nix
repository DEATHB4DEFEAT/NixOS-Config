{
    lib,
    ...
}:

{
    programs.foot = {
        enable = true;
        settings = {
            main = {
                # font = "monospace:size=16";
                dpi-aware = lib.mkForce "yes";
                gamma-correct-blending = "no";
            };

            scrollback = {
                lines = 10000;
            };

            mouse = {
                hide-when-typing = "yes";
            };

            colors-light = {
                alpha = lib.mkForce 0.0;
                blur = "yes";
                # background = "1a1a1a";
                # selection-background = "000000";
                # selection-foreground = "ffffff";
            };
        };
    };
}
