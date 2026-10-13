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
        workspace_back_and_forth = 0,
    },
}

hl.device{
    name = "compx-2.4g-wireless-receiver-1",
    sensitivity = -1,
    accel_profile = "adaptive",
}

local binds = {
    { "SUPER + RETURN", hl.dsp.exec_cmd'foot' },
    { "SUPER + E", hl.dsp.exec_cmd'dolphin' },
    { "SUPER + Q", hl.dsp.window.close() },
    -- { "SUPER + SPACE", hl.dsp.exec_cmd'launcher_t6' },
    { "SUPER + SPACE", hl.dsp.exec_cmd'rofi -show drun -theme $HOME/.setup/home-manager/config/hyprland/rofi/rounded-purple.rasi' },

    { "Print", hl.dsp.exec_cmd[[grimblast --freeze save area - > /tmp/screenshot.png; wl-copy < /tmp/screenshot.png; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload]] },
    { "ALT + Print", hl.dsp.exec_cmd[[grimblast --freeze save area - > /tmp/screenshot.png; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload | wl-copy]] },
    { "SHIFT + Print", hl.dsp.exec_cmd[[grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload]] },
    { "ALT + SHIFT + Print", hl.dsp.exec_cmd[[grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --disable-notifications --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -; curl -F "somefile=@/tmp/screenshot.png" https://img.simplemodbot.tk/upload | wl-copy]] },

    { "SUPER + SHIFT + mouse_down", hl.dsp.exec_cmd"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.25')" },
    { "SUPER + SHIFT + mouse_up", hl.dsp.exec_cmd"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float / 1.25) | if . < 1 then 1 else . end')" },

    { "XF86AudioMute", hl.dsp.exec_cmd[[wpctl set-mute $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id') toggle]] },
    { "SUPER + XF86AudioMute", hl.dsp.exec_cmd[[hyprctl notify "1 2500 rgb(ffffff) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id'))"]] },
    { "XF86AudioMicMute", hl.dsp.exec_cmd"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
    { "XF86AudioPlay", hl.dsp.exec_cmd"playerctl play-pause" },
    { "XF86AudioPause", hl.dsp.exec_cmd"playerctl play-pause" },
    { "XF86AudioNext", hl.dsp.exec_cmd"playerctl next" },
    { "XF86AudioPrev", hl.dsp.exec_cmd"playerctl previous" },

    { "SUPER + L", hl.dsp.exec_cmd'hyprlock' },
    { "SUPER + R", hl.dsp.exec_cmd'hyprctl reload' },
    { "SUPER + F", hl.dsp.window.float() },
    { "F11", hl.dsp.window.fullscreen() },
    { "SUPER + SHIFT + F", hl.dsp.window.tag({ tag = "bigscreen" }) },
    { "SUPER + SHIFT + F", hl.dsp.exec_cmd"hyprctl dispatch fakefullscreen; hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 3840 1080; hyprctl dispatch moveactive exact 0 0" },
    { "SUPER + Tab", hl.dsp.window.cycle_next() },
    { "SUPER + J", hl.dsp.exec_cmd"wl-kbptr -c $HOME/.setup/home-manager/config/apps/config/wl-kbptr" },
    { "SUPER + CTRL + 1", hl.dsp.focus({ monitor = 0 }) },
    { "SUPER + CTRL + 2", hl.dsp.focus({ monitor = 1 }) },
    { "SUPER + CTRL + 3", hl.dsp.focus({ monitor = 2 }) },
    { "SUPER + W", hl.dsp.workspace.toggle_special("magic") },
    { "SUPER + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }) },
    { "SUPER + bracketright", hl.dsp.exec_cmd"pkill hyprpanel || hyprpanel" },

    { "SUPER + mouse_down", hl.dsp.layout("move +col") },
    { "SUPER + mouse_up", hl.dsp.layout("move -col") },

    --? Repeating
    { "XF86AudioRaiseVolume", hl.dsp.exec_cmd[[wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id') 5%+; hyprctl notify "1 2500 rgb(00ff00) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id'))"]], repeating = true },
    { "XF86AudioLowerVolume", hl.dsp.exec_cmd[[wpctl set-volume -l 1.5 $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id') 5%-; hyprctl notify "1 2500 rgb(ff0000) fontsize:50 $(wpctl get-volume $(pw-dump | jq '.[] | select(.info.props."node.nick" == "HyperX QuadCast") | select(.info.props."media.class" == "Audio/Sink").id'))"]], repeating = true },

    --? Mouse
    { "SUPER + mouse:272", hl.dsp.window.drag(), mouse = true },
    { "SUPER + mouse:273", hl.dsp.window.resize(), mouse = true },

    --? Locked
    { "SUPER + SHIFT + L", hl.dsp.exit(), locked = true },
    { "SUPER + Z", hl.dsp.exec_cmd"$HOME/.setup/home-manager/config/hyprland/scripts/switch-layout.sh", locked = true },
}

for i = 1, 5 do
    local key = i % 10 -- 10 is 0
    hl.bind("SUPER + "..key, hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + "..key, hs.dsp.window.move({ workspace = i, follow = false }))
end

BIND_ALL(binds)
