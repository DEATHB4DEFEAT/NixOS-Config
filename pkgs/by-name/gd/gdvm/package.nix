{
    lib,
    rustPlatform,
    fetchFromGitHub,
    pkg-config,
    openssl
}:


rustPlatform.buildRustPackage {
    pname = "gdvm";
    version = "0.5.0";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];

    src = fetchFromGitHub {
        owner = "adalinesimonian";
        repo = "gdvm";
        rev = "529d6af507bc41ff3e7d8e7b6b8793ae2b1985f3";
        hash = "sha256-qd+EHHQtMSQMEAaCxZX2zTKimL5Zgw0pWq4/nHVvJGA=";
    };

    cargoLock = {
        lockFile = ./Cargo.lock;
    };

    cargoPatches = [
        ./Cargo.lock.patch
    ];

    meta = {
        description = "Godot Version Manager";
        homepage = "https://github.com/adalinesimonian/gdvm";
        license = lib.licenses.isc;
        mainProgram = "gdvm";
        maintainers = [
            lib.maintainers.DEATHB4DEFEAT
        ];
        platforms = lib.platforms.linux;
    };
}
