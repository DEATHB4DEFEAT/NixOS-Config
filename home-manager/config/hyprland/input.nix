{
    lib,
    ...
}:

{
    wayland.windowManager.hyprland = {
        settings = let
            inherit (import ./variables.nix)
                workspaces
                browser
                terminal
                plasmashell
                keyboardLayout
            ;
        in
        {
            input = {
                follow_mouse = 1;
                kb_layout = lib.concatStringsSep ", " keyboardLayout.layouts;
                kb_options = lib.concatStringsSep ", " keyboardLayout.options;
                repeat_rate = 25;
                repeat_delay = 250;
            };

            misc = {
                middle_click_paste = false;
            };

            bind = [
                # "SUPER, B, exec, ${browser}"
                "SUPER, RETURN, exec, ${terminal}"
                "SUPER, E, exec, dolphin"
                "SUPER, Q, killactive"
                ", Print, exec, hyprshot -m region --clipboard-only --silent"

                # Volume
                ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
                ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
                ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
                ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"

                # Media
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioPause, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"

                # System
                "SUPER, L, exec, hyprlock"
                "SUPERSHIFT, L, exec, hyprctl dispatch exit"
                "SUPER, R, exec, hyprctl reload"
                "SUPER, F, togglefloating"
                ", F11, fullscreen"
                "SUPER, Tab, cyclenext"
            ]
            ++ (
                builtins.concatLists (
                    # Workspaces
                    # Binds SUPER + [shift +] {1..10} to [move to] workspace {1..10}
                    builtins.genList (
                        x: let
                            ws = builtins.toString (if x == 9 then 0 else x + 1);
                        in
                        [
                            #? Default Hyprland
                            # "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                            # "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                            #? split-monitor-workspaces plugin
                            "SUPER, ${ws}, split-workspace, ${toString (x + 1)}"
                            "SUPER SHIFT, ${ws}, split-movetoworkspacesilent, ${toString (x + 1)}"
                        ]
                    ) workspaces
                )
            ) ++ (if plasmashell then [
                "SUPER, Space, exec, krunner"
            ] else []);

            bindm = [
                "SUPER, mouse:272, movewindow"
                "SUPER, mouse:273, resizewindow"
            ];
        };
    };
}
