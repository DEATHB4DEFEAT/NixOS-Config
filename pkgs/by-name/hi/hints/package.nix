{
    pkgs,
    lib,

    git,
    ydotool,
    gobject-introspection,
    gcc,
    cairo,
    pkg-config,
    python3,
    gtk3,
    python3Packages,
    python312Packages,
    intltool,
    wrapGAppsHook3,

    gtk-layer-shell,
    grim,
}:

python3Packages.buildPythonPackage {
    pname = "hints";
    version = "git";

    src = pkgs.fetchFromGitHub {
        owner = "AlfredoSequeida";
        repo = "hints";
        rev = "6dd72ae5444002c3fa35d54a7a3c55db4de1cdab";
        sha256 = "sha256-pWP8XVrFpzZ3xhLvsrerOyBMX0qx6v4DWahXTahqUZY=";
    };

    nativeBuildInputs = [
        gobject-introspection
        intltool
        pkg-config
        wrapGAppsHook3
        python3Packages.setuptools
    ];

    buildInputs = [
        git
        ydotool
        gcc
        cairo
        python3
        gtk3
        python3Packages.pillow
        python312Packages.pygobject3
        python312Packages.opencv4
    ] ++ (if pkgs.stdenv.isLinux && builtins.getEnv "XDG_SESSION_TYPE" == "wayland" then [
        gtk-layer-shell
        grim
    ] else []);

    pythonPath = with python3Packages; [
        dbus-python
        distutils-extra
        pyatspi
        pycairo
        pygobject3
        systemd
        opencv4
        pyscreenshot
    ];

    # patches = [
    #     ./log.patch
    # ];

    meta = {
        description = "Hints lets you navigate GUI applications in Linux without your mouse by displaying \"hints\" you can type on your keyboard to interact with GUI elements.";
        homepage = "https://github.com/AlfredoSequeida/hints";
        license = lib.licenses.gpl3;
        maintainers = [
            lib.maintainers.DEATHB4DEFEAT
        ];
        platforms = lib.platforms.linux;
    };
}
