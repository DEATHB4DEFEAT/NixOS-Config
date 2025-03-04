{
    lib,
    fetchFromGitHub,
    meson,
    ninja,
    pkg-config,
    pango,
    cairo,
    hyprland,
    hyprlandPlugins,
}:

hyprlandPlugins.mkHyprlandPlugin hyprland {
    pluginName = "split-monitor-workspaces";
    version = "0.38.1";

    src = fetchFromGitHub {
        "owner"= "Duckonaut";
        "repo"= "split-monitor-workspaces";
        "rev"= "e5f81273e737494678f347e3f2babbd376f04e22";
        "hash"= "sha256-KG+fN7wUsDDkI2BNxMwsHOzk49LJY8piP/ZEjT2yJGg=";
    };

    nativeBuildInputs = [
        meson
        ninja
        pkg-config
    ];

    buildInputs = [
        hyprland.dev
        pango
        cairo
    ];

    meta = {
        homepage = "https://github.com/Duckonaut/split-monitor-workspaces";
        description = "A small Hyprland plugin to provide awesome-like workspace behavior";
        license = lib.licenses.bsd3;
        platforms = lib.platforms.linux;
    };
}
