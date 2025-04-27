{
    lib,
    rustPlatform,
    fetchFromGitHub,
    pkg-config,
    openssl
}:


rustPlatform.buildRustPackage {
    pname = "robust-lsp";
    version = "0.9.0";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];

    src = fetchFromGitHub {
        owner = "Ertanic";
        repo = "robust-lsp";
        rev = "509c3c5507e95ba7750834bec023977c38578138";
        hash = "sha256-xqJH1IbQyUUV5f3RwAivOS7jgQFWuIAhAjxF7ag+Ucs=";
    };

    cargoLock = {
        lockFile = ./Cargo.lock;
        outputHashes = {
            "fluent-syntax-0.11.1" = "sha256-Rf7aN0DVV3LAgU8h3udLPIjVScLZg3rIayoZ06h0zak=";
        };
    };

    meta = {
        description = "Robust Language Server";
        homepage = "https://github.com/Ertanic/robust-lsp";
        license = lib.licenses.gpl3;
        mainProgram = "robust-lsp";
        maintainers = [
            lib.maintainers.DEATHB4DEFEAT
        ];
        platforms = lib.platforms.linux;
    };
}
