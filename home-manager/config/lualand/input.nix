{
    lib,
    ...
}:

let
    lua = lib.generators.mkLuaInline;
    dsp = {
        exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
        close = lua "hl.dsp.window.close()";
        fullscreen = lua "hl.dsp.window.fullscreen()";
        float = lua ''hl.dsp.window.float({ action = "toggle" })'';
        tag = tag: lua ''hl.dsp.window.tag("${tag}")'';
        cyclenext = lua "hl.dsp.window.cycle_next()";
        focusmonitor = monitor: lua ''hl.dsp.focus({ ${monitor} })'';
        togglespecialworkspace = ws: lua ''hl.dsp.workspace.toggle_special("${ws}")'';
        movetoworkspace = ws: lua ''hl.dsp.window.move({ workspace = "${ws}" })'';
        workspace = ws: lua ''smw.workspace("${ws}")'';
        movetoworkspacesilent = ws: lua ''smw.move_to_workspace_silent("${ws}")'';
    };
    bind = keys: dispatcher: { _args = [ keys dispatcher ]; };
in
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

            device = [
                {
                    name = "compx-2.4g-wireless-receiver-1";
                    sensitivity = -1;
                    # accel_profile = "custom 200 0 0.5";
                    accel_profile = "adaptive";
                }
            ];


            binds = {
                scroll_event_delay = 0;
            };

            bind = [
                # "SUPER, B, exec, ${browser}"
                (bind "SUPER, RETURN" dsp.exec terminal)
                (bind "SUPER, E" dsp.exec "dolphin")
                (bind "SUPER, Q" dsp.close)

                # Screenshots
                # ", Print, exec, hyprshot -m region --clipboard-only --silent"
                (bind "Print" dsp.exec "grimblast --freeze save area - > /tmp/screenshot.png; wl-copy < /tmp/screenshot.png; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload")
                (bind "ALT + Print" dsp.exec "grimblast --freeze save area - > /tmp/screenshot.png; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload | wl-copy")
                (bind "SHIFT + Print" dsp.exec "grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload")
                (bind "ALT + SHIFT + Print" dsp.exec "grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F \"somefile=@/tmp/screenshot.png\" https://img.simplemodbot.tk/upload | wl-copy")

                # Zoom
                (bind "SUPER SHIFT + mouse_down" dsp.exec "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.25')")
                (bind "SUPER SHIFT + mouse_up" dsp.exec "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float / 1.25) | if . < 1 then 1 else . end')")

                # Volume
                # ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                (bind "XF86AudioMute" dsp.exec "wpctl set-mute $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id') toggle") # ", XF86AudioMute, exec, wpctl set-mute $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id') toggle"
                (bind "SUPER + XF86AudioMute" dsp.exec "hyprctl notify \"1 2500 rgb(ffffff) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id'))\"") # "SUPER, XF86AudioMute, exec, hyprctl notify \"1 2500 rgb(ffffff) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id'))\""
                (bind "XF86AudioMicMute" dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") # ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

                # Media
                (bind "XF86AudioPlay" dsp.exec "playerctl play-pause") # ", XF86AudioPlay, exec, playerctl play-pause"
                (bind "XF86AudioPause" dsp.exec "playerctl play-pause") # ", XF86AudioPause, exec, playerctl play-pause"
                (bind "XF86AudioNext" dsp.exec "playerctl next") # ", XF86AudioNext, exec, playerctl next"
                (bind "XF86AudioPrev" dsp.exec "playerctl previous") # ", XF86AudioPrev, exec, playerctl previous"

                # System
                (bind "SUPER + L" dsp.exec "hyprlock") # "SUPER, L, exec, hyprlock"
                (bind "SUPER + R" dsp.exec "hyprctl reload") # "SUPER, R, exec, hyprctl reload"
                (bind "SUPER + F" dsp.float) # "SUPER, F, togglefloating"
                (bind "F11" dsp.fullscreen) # ", F11, fullscreen"
                (bind "SUPER + SHIFT + F" dsp.tag "bigscreen") # "SUPER SHIFT, F, tagwindow, bigscreen"
                (bind "SUPER + SHIFT + F" dsp.exec "hyprctl dispatch fakefullscreen; hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 3840 1080; hyprctl dispatch moveactive exact 0 0") # "SUPER SHIFT, F, exec, hyprctl dispatch fakefullscreen; hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 3840 1080; hyprctl dispatch moveactive exact 0 0"
                (bind "SUPER + Tab" dsp.cyclenext) # "SUPER, Tab, cyclenext"
                (bind "SUPER + J" dsp.exec "wl-kbptr -c $HOME/.setup/home-manager/config/apps/config/wl-kbptr") # "SUPER, J, exec, wl-kbptr -c $HOME/.setup/home-manager/config/apps/config/wl-kbptr"
                (bind "SUPER CTRL, 1" dsp.focusmonitor 0) # "SUPER CTRL, 1, focusmonitor, 0"
                (bind "SUPER CTRL, 2" dsp.focusmonitor 1) # "SUPER CTRL, 2, focusmonitor, 1"
                (bind "SUPER CTRL, 3" dsp.focusmonitor 2) # "SUPER CTRL, 3, focusmonitor, 2"

                # Scroll
                (bind "SUPER + mouse_down" dsp.layout "move -col") # "SUPER, mouse_down, layoutmsg, move -col"
                (bind "SUPER + mouse_up" dsp.layout "move +col") # "SUPER, mouse_up, layoutmsg, move +col"

                # Workspaces
                (bind "SUPER + W" dsp.togglespecialworkspace "magic") # "SUPER, W, togglespecialworkspace, magic"
                (bind "SUPER + SHIFT + W" dsp.movetoworkspace "special:magic") # "SUPER SHIFT, W, movetoworkspace, special:magic"
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
                            (bind "SUPER + ${ws}" dsp.workspace "${ws}") # "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                            (bind "SUPER + SHIFT + ${ws}" dsp.movetoworkspacesilent "${ws}") # "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                        ]
                    ) workspaces
                )
            ) ++ (if plasmashell then [
                (bind "SUPER + Space" dsp.exec "krunner") #"SUPER, Space, exec, krunner"
            ] else []);

            # Repeat on hold
            binde = [
                # Volume
                # ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
                # ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
                (bind "XF86AudioRaiseVolume" dsp.exec "wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id') 5%+; hyprctl notify \"1 2500 rgb(00ff00) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id'))\"") # ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id') 5%+; hyprctl notify \"1 2500 rgb(00ff00) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id'))\""
                (bind "XF86AudioLowerVolume" dsp.exec "wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id') 5%-; hyprctl notify \"1 2500 rgb(ff0000) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id'))\"") # ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id') 5%-; hyprctl notify \"1 2500 rgb(ff0000) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props.\"node.nick\" == \"HyperX QuadCast\") | select(.info.props.\"media.class\" == \"Audio/Sink\").id'))\""
            ];

            # Mouse movement
            bindm = [
                (bind "SUPER + mouse:272" dsp.movewindow) # "SUPER, mouse:272, movewindow"
                (bind "SUPER + mouse:273" dsp.resizewindow) # "SUPER, mouse:273, resizewindow"
            ];

            # Usable while locked
            bindl = [
                # System
                (bind "SUPER + SHIFT + L" dsp.exec "hyprctl dispatch exit") # "SUPER SHIFT, L, exec, hyprctl dispatch exit"
                (bind "SUPER + Z" dsp.exec "$HOME/.setup/home-manager/config/hyprland/scripts/switch-layout.sh") # "SUPER, Z, exec, $HOME/.setup/home-manager/config/hyprland/scripts/switch-layout.sh"
            ];
        };
    };
}
