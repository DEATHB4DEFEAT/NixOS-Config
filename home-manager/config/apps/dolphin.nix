{
    ...
}:

{
    xdg.dataFile."kio/servicemenus/add-to-steam.desktop".text = ''
        [Desktop Entry]
        Type=Service
        MimeType=application/x-ms-dos-executable;application/x-executable;application/x-shellscript;application/x-desktop;
        Actions=AddToSteam;

        [Desktop Action AddToSteam]
        Name=Add to Steam
        Icon=steam
        Exec=${./add-to-steam.sh} "%f"
    '';
}
