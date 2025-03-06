{
    programs.hyprlock = {
        enable = true;

        # Edited version of https://github.com/MrVivekRajan/Hyprlock-Styles/blob/e8489df1de8a1f589f90e14cc799bc14262144c5/Style-10/hyprlock.conf
        settings = {
            background = {
                path = "screenshot";
                blur_passes = 2;
                blur_size = 7;
            };


            label = [
                # Weekday
                {
                    monitor = "DP-1";
                    text = "cmd[update:1000] echo -e \"$(date +\"%A\")\"";
                    color = "rgba(216, 222, 233, 0.70)";
                    font_size = 180;
                    font_family = "Jetbrains Mono ExtraBold";
                    position = "0, 700";
                    halign = "center";
                    valign = "center";
                }

                # Date
                {
                    monitor = "DP-1";
                    text = "cmd[update:1000] echo -e \"$(date +\"%B %d, %Y\")\"";
                    color = "rgba(216, 222, 233, 0.70)";
                    font_size = 80;
                    font_family = "Jetbrains Mono ExtraBold";
                    position = "0, 500";
                    halign = "center";
                    valign = "center";
                }

                # Time
                {
                    monitor = "DP-1";
                    text = "cmd[update:1] echo -e \"- $(date +\"%X\") -\"";
                    color = "rgba(216, 222, 233, 0.70)";
                    font_size = 40;
                    font_family = "Jetbrains Mono ExtraBold";
                    position = "0, 380";
                    halign = "center";
                    valign = "center";
                }

                # User
                {
                    monitor = "DP-1";
                    text = " $USER";
                    color = "rgba(216, 222, 233, 0.80)";
                    outline_thickness = 2;
                    dots_size = 0.2;
                    dots_spacing = 0.2;
                    dots_center = true;
                    font_size = 36;
                    font_family = "Jetbrains Mono ExtraBold";
                    position = "0, -260";
                    halign = "center";
                    valign = "center";
                }

                # Power
                {
                    monitor = "DP-1";
                    text = "󰐥  󰜉  󰤄";
                    color = "rgba(255, 255, 255, 0.6)";
                    font_size = 100;
                    position = "0, 200";
                    halign = "center";
                    valign = "bottom";
                }
            ];

            image = [
                # Profile Picture
                {
                    monitor = "DP-1";
                    path = toString ./pfp.png;
                    border_size = 2;
                    border_color = "rgba(255, 255, 255, .65)";
                    size = 260;
                    position = "0, 80";
                }
            ];

            shape = [
                # User Box
                {
                    monitor = "DP-1";
                    size = "600, 120";
                    color = "rgba(255, 255, 255, .1)";
                    rounding = -1;
                    border_size = 0;
                    border_color = "rgba(255, 255, 255, 0)";
                    position = "0, -260";
                }
            ];

            input-field = [
                # Password
                {
                    monitor = "DP-1";
                    size = "600, 120";
                    outline_thickness = 2;
                    dots_size = 0.2;
                    dots_spacing = 0.2;
                    dots_center = true;
                    outer_color = "rgba(255, 255, 255, 0)";
                    inner_color = "rgba(255, 255, 255, 0.1)";
                    font_color = "rgb(200, 200, 200)";
                    fade_on_empty = false;
                    font_family = "Jetbrains Mono ExtraBold";
                    placeholder_text = "<i><span foreground=\"##ffffff99\">Enter Password</span></i>";
                    hide_input = false;
                    position = "0, -420";
                    halign = "center";
                    valign = "center";
                }
            ];
        };
    };
}
