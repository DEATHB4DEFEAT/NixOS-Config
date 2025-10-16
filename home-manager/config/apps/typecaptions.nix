{
    pkgs,
    ...
}:

{
    xdg.desktopEntries = {
        typecaptions = {
            name = "TypeCaptions";
            exec = "foot -H ${pkgs.nodejs-slim_24}/bin/node ${builtins.toString ./typecaptions.js}";
            icon = "subtitles";
            type = "Application";
            categories = [ "Utility" ];
        };
    };
}
