{
    pkgs
}:

{
    forgeServers = pkgs.callPackage ./forgeServers/. {};
    fetchModrinthModpack = pkgs.callPackage ./fetchModrinthModpack.nix {};
}
