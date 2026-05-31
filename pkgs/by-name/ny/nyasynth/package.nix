{
    lib,
    rustPlatform,
    fetchFromGitHub,
    pkg-config,
    libGL,
    libx11,
    libxcursor,
    alsa-lib,
    libjack2,
    libxcb,
    python3,
    libxcb-wm,
}:


rustPlatform.buildRustPackage {
    pname = "nyasynth";
    version = "1.0.0"; # not quite but shhh

    outputs = [ "out" ];

    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libGL libx11 libxcursor alsa-lib libjack2 libxcb libxcb-wm ];

    src = fetchFromGitHub {
        owner = "a2aaron";
        repo = "nyasynth";
        rev = "8e60cfe0fe0091d1446779e1d35ea2da6279110e";
        hash = "sha256-Snjf45WwffZvD7jH4XEfHYlbv3Amk0Gu0jsAIKbBpOw=";
    };

    cargoHash = "sha256-39QCCRhzBif9ekLyfTU8aOJElULUwb56u0fr1tSVV0I=";

    # iunno
    # cargoBuildFlags = [
    #     "xtask"
    #     "bundle"
    #     "nyasynth"
    #     "--release"
    # ];
    postBuild = ''
        cargo xtask bundle nyasynth --release
        mkdir -p $out/lib/clap
        mkdir -p $out/lib/vst3
        cp /build/source/target/bundled/nyasynth.clap $out/lib/clap/nyasynth.clap
        cp -r /build/source/target/bundled/nyasynth.vst3 $out/lib/vst3/nyasynth.vst3
    '';

    meta = {
        homepage = "https://github.com/a2aaron/nyasynth";
        mainProgram = "nyasynth";
        maintainers = [
            lib.maintainers.DEATHB4DEFEAT
        ];
        platforms = lib.platforms.linux;
    };
}
