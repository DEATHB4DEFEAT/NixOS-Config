{
    lib,
    rustPlatform,
    fetchFromGitHub,
    pkg-config,
    openssl
}:


rustPlatform.buildRustPackage {
    pname = "robust-lsp";
    version = "0.5.3";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];

    src = fetchFromGitHub {
        owner = "Ertanic";
        repo = "robust-lsp";
        rev = "643bc8d047286a99751f4360b7dc52333f239cf8";
        hash = "sha256-NxYjcY7I6GSZzjIazjEMFeK/Dwan8a3uYlZBRxgQvK0=";
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
