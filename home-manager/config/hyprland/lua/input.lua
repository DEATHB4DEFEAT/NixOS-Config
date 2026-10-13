hl.config{
    input = {
        follow_mouse = 1,
        kb_layout = "us, custom",
        kb_options = "grp_led:scroll",
        repeat_rate = 25,
        repeat_delay = 250,
    },
    misc = {
        middle_click_paste = false,
    },
    binds = {
        scroll_event_delay = 0,
    },
}

-- device[]
hl.device{
    name = "compx-2.4g-wireless-receiver-1",
    sensitivity = -1,
    accel_profile = "adaptive",
}

-- package.path = package.path..";./?.lua;./?/init.lua"
-- local smw = require("plugins.split-monitor-workspaces")

local binds = {
    { "SUPER + T", hl.dsp.exec_cmd'foot' },
    { "SUPER + Q", hl.dsp.window.close() },
    { "SUPER + M", hl.dsp.exit(), locked = true },
}

local bind = {
    { "SUPER", "RETURN", "exec", "foot" },
    { "SUPER", "E", "exec", "dolphin" },
    { "SUPER", "Q", "killactive" },
    { "SUPER", "Space", "exec", "launcher_t6" },

    { "", "Print", "exec", [[grimblast --freeze save area - > /tmp/screenshot.png; wl-copy < /tmp/screenshot.png; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload]] },
    { "ALT", "Print", "exec", [[grimblast --freeze save area - > /tmp/screenshot.png; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload | wl-copy]] },
    { "SHIFT", "Print", "exec", [[grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload]] },
    { "ALT SHIFT", "Print", "exec", [[grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload | wl-copy]] },

    { "SUPER SHIFT", "mouse_down", "exec", "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.25')" },
    { "SUPER SHIFT", "mouse_up", "exec", "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float / 1.25) | if . < 1 then 1 else . end')" },

    { "", "XF86AudioMute", "exec", [[wpctl set-mute $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id') toggle]] },
    { "SUPER", "XF86AudioMute", "exec", [[hyprctl notify "1 2500 rgb(ffffff) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id'))"]] },
    { "", "XF86AudioMicMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
    { "", "XF86AudioPlay", "exec", "playerctl play-pause" },
    { "", "XF86AudioPause", "exec", "playerctl play-pause" },
    { "", "XF86AudioNext", "exec", "playerctl next" },
    { "", "XF86AudioPrev", "exec", "playerctl previous" },

    { "SUPER", "L", "exec", "hyprlock" },
    { "SUPER", "R", "exec", "hyprctl reload" },
    { "SUPER", "F", "togglefloating" },
    { "", "F11", "fullscreen" },
    { "SUPER SHIFT", "F", "tagwindow", "bigscreen" },
    { "SUPER SHIFT", "F", "exec", "hyprctl dispatch fakefullscreen; hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 3840 1080; hyprctl dispatch moveactive exact 0 0" },
    { "SUPER", "Tab", "cyclenext" },
    { "SUPER", "J", "exec", "wl-kbptr -c $HOME/.setup/home-manager/config/apps/config/wl-kbptr" },
    { "SUPER CTRL", "1", "focusmonitor", "0" },
    { "SUPER CTRL", "2", "focusmonitor", "1" },
    { "SUPER CTRL", "3", "focusmonitor", "2" },
    { "SUPER", "mouse_down", "layoutmsg", "move -col" },
    { "SUPER", "mouse_up", "layoutmsg", "move +col" },
    { "SUPER", "W", "togglespecialworkspace", "magic" },
    { "SUPER SHIFT", "W", "movetoworkspace", "special:magic" },
    { "SUPER", "bracketright", "exec", "pkill hyprpanel || hyprpanel" },
}

-- for workspace = 1, 5 do
--     local key = workspace == 5 and "0" or tostring(workspace)
--     hl.bind("SUPER + " .. key, smw.workspace(tostring(workspace)))
--     hl.bind("SUPER SHIFT + " .. key, smw.move_to_workspace_silent(tostring(workspace)))
-- end
for i = 1, 5 do
    local key = i % 10 -- 10 is 0
    hl.bind("SUPER + "..key, hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + "..key, hs.dsp.window.move({ workspace = i, follow = false }))
end

BIND_ALL(binds)

-- hl.binde{
--     { "", "XF86AudioRaiseVolume", "exec", [[wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id') 5%+; hyprctl notify "1 2500 rgb(00ff00) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id'))"]] },
--     { "", "XF86AudioLowerVolume", "exec", [[wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id') 5%-; hyprctl notify "1 2500 rgb(ff0000) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id'))"]] },
-- }

-- hl.bindm{
--     { "SUPER", "mouse:272", "movewindow" },
--     { "SUPER", "mouse:273", "resizewindow" },
-- }

-- hl.bindl{
--     { "SUPER SHIFT", "L", "exec", "hyprctl dispatch exit" },
--     { "SUPER", "Z", "exec", "$HOME/.setup/home-manager/config/hyprland/scripts/switch-layout.sh" },
-- }
