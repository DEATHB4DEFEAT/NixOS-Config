{
    wayland.windowManager.hyprland = {
        settings = {
            general = {
                # gaps_in = 2;
                # gaps_out = 4;
                gaps_in = 0;
                gaps_out = 0;
                border_size = 2;
                # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.active_border" = "rgba(9b59b6ee) rgba(71368aee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                layout = "dwindle";
            };

            decoration = {
                # rounding = 8;
                rounding = 0;

                dim_inactive = true;
                dim_strength = 0.1;

                blur = {
                    enabled = true;
                    size = 7;
                    passes = 2;
                    vibrancy = 0.1696;
                    new_optimizations = true;
                };

                shadow = {
                    enabled = false;
                    range = 5;
                    render_power = 2;
                    color = "rgba(1a1a1aee)";
                };
            };

            animations = {
                enabled = true;

                bezier = [
                    "myBezier, 0.05, 0.9, 0.1, 1.05"
                ];
                animation = [
                    "windows, 1, 5, myBezier"
                    "windowsOut, 1, 5, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
                ];
            };
        };
    };
}
