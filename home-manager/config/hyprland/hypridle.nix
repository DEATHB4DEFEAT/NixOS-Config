{
    services.hypridle = {
        enable = true;
        settings = {
            general = {
                lock_cmd = "hyprlock";
                before_sleep_cmd = "hyprctl dispatch dpms off";
                after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
                {
                    timeout = 540; # 9 minutes
                    on-timeout = "brightnessctl set 25%";
                    on-resume = "brightnessctl set 100%";
                }
                {
                    timeout = 570; # 9.5 minutes
                    on-timeout = "hyprlock";
                }
                {
                    timeout = 600; # 10 minutes
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
                {
                    timeout = 1800; # 30 minutes
                    on-timeout = "pkill hyprpanel; systemctl suspend";
                    on-resume = "hyprpanel";
                }
            ];
        };
    };
}
