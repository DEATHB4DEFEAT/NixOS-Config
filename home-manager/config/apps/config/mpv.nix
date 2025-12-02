{
    ...
}:

{
    programs.mpv = {
        enable = true;
        config = {
            volume = 50;
            audio-device = "pipewire/Null-Music-Sink";
        };
    };
}
