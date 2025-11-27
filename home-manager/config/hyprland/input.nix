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

            binde = [
                # Volume
                ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
                ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
            ];

            bind = [
                # "SUPER, B, exec, ${browser}"
                "SUPER, RETURN, exec, ${terminal}"
                "SUPER, E, exec, dolphin"
                "SUPER, Q, killactive"

                # Screenshots
                # ", Print, exec, hyprshot -m region --clipboard-only --silent"
                ", Print, exec, grimblast --freeze save area - > /tmp/screenshot.png; wl-copy < /tmp/screenshot.png; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload"
                "ALT, Print, exec, grimblast --freeze save area - > /tmp/screenshot.png; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload | wl-copy"
                "SHIFT, Print, exec, grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload"
                "ALT SHIFT, Print, exec, grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload | wl-copy"

                # Volume
                ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

                # Media
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioPause, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"

                # System
                "SUPER, L, exec, hyprlock"
                "SUPER SHIFT, L, exec, hyprctl dispatch exit"
                "SUPER, R, exec, hyprctl reload"
                "SUPER, F, togglefloating"
                ", F11, fullscreen"
                "SUPER, Tab, cyclenext"
                "SUPER, J, exec, wl-kbptr -c $HOME/.setup/home-manager/config/apps/config/wl-kbptr"
                "SUPER CTRL, 1, focusmonitor, 0"
                "SUPER CTRL, 2, focusmonitor, 1"
                "SUPER CTRL, 3, focusmonitor, 2"
                "SUPER, Z, exec, $HOME/.setup/home-manager/config/hyprland/scripts/switch-layout.sh"

                # Workspaces
                "SUPER, W, togglespecialworkspace, magic"
                "SUPER SHIFT, W, movetoworkspace, special:magic"
            ]
            # Also workspaces
            ++ (
                builtins.concatLists (
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
