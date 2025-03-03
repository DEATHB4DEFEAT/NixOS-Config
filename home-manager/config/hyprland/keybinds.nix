{
    wayland.windowManager.hyprland = {
        settings = {
            bind =
                [
                    # "SUPER, F, exec, firefox"
                    "SUPER, RETURN, exec, foot"
                    "SUPER, E, exec, dolphin"
                    "SUPER, Q, killactive"
                    "SUPER, Space, exec, krunner"

                    ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
                    ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
                    ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
                    ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioNext, exec, playerctl next"
                    ", XF86AudioPrev, exec, playerctl previous"

                    "SUPER, L, exec, hyprctl dispatch exit"
                    "SUPER, R, exec, hyprctl reload"
                    "SUPER, F, togglefloating"
                    ", F11, fullscreen"
                    "SUPER, Tab, cyclenext"
                ]
                ++ (
                    # Workspaces
                    # Binds SUPER + [shift +] {1..10} to [move to] workspace {1..10}
                    builtins.concatLists (
                        builtins.genList (
                            x:
                                let ws =
                                    let c = (x + 1) / 10;
                                    in builtins.toString (x + 1 - (c * 10));
                            in
                            [
                                "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                                "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                            ]
                        ) 10
                    )
                );
        };
    };
}
