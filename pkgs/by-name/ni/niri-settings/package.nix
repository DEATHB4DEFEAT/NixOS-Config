{
    lib,
    pkgs,
    fetchFromGitHub,
    python3,
    niri,
}:

let
    src = fetchFromGitHub {
        owner = "stefonarch";
        repo = "niri-settings";
        rev = "a4cd78bb78730add87b0f8ba1cdd4625f1e7af9a";
        sha256 = "sha256-gMvuILqMIihs4mvDrlDNU3kgkdMKKjsxPzXwEe25GQw=";
    };
in
pkgs.writeShellApplication {
    name = "niri-settings";

    runtimeInputs = [
        (python3.withPackages (ps: with ps; [
            pyqt6
        ]))
        niri
    ];

    text = ''
        export PYTHONPATH="${src}/"
        python "${src}/niri_settings.py"
    '';

    meta = with lib; {
        description = "Configuration GUI for niri (Wayland compositor)";
        homepage = "https://github.com/stefonarch/niri-settings";
        license = licenses.gpl2;
        maintainers = [
            lib.maintainers.DEATHB4DEFEAT
        ];
    };
}
