{ lib, stdenv, fetchFromGitHub
, autoconf, libndctl, pkg-config, gnum4, pandoc
}:

stdenv.mkDerivation rec {
  pname = "pmdk";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner  = "daos-stack";
    repo   = "pmdk";
    rev    = "refs/tags/${version}";
    hash = "sha256-rjBhmYccqu1R7CrUQ1DDMHzd3ZdPJ7zOBpOcNsfeo2Q=";
  };

  nativeBuildInputs = [ autoconf pkg-config gnum4 pandoc ];
  buildInputs = [ libndctl ];
  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  makeFlags = [ "SRCVERSION=${version}" ];

  postPatch = ''
    patchShebangs utils

    # Force common.inc to accept your static version directly, bypassing git completely
    substituteInPlace src/common.inc \
      --replace-fail 'export SRCVERSION := $(shell git describe --always)' 'export SRCVERSION := ${version}'
  '';

  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
    "-I${lib.getDev libndctl}/include/daxctl"
    "-isystem ${lib.getDev libndctl}/include"
  ];

  installPhase = ''
    runHook preInstall

    make install prefix=$out

    mkdir -p $lib/lib $dev/include $man/share

    # Safely copy files to keep symlinks pristine
    cp -av $out/lib/. $lib/lib/
    rm -rf $out/lib

    cp -av $out/include/. $dev/include/
    rm -rf $out/include

    cp -av $out/share/man/. $man/share/man/
    rm -rf $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Persistent Memory Development Kit";
    homepage    = "https://github.com";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = [ "x86_64-linux" ];
  };
}
