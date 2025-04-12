{
    pkgs,
    ...
}:

{
    home.file.".local/share/jellyfinmediaplayer/scripts/mpris.so".source =
        "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
}
