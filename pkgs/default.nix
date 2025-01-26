{
    pkgs,
    lib,
    baseDirectory ? ./by-name
}:

let
    namesForShard =
        shard: type:
        if type != "directory" then
            { }
        else
            lib.mapAttrs
                (name: _: baseDirectory + "/${shard}/${name}/package.nix")
                (builtins.readDir (baseDirectory + "/${shard}"));
    packageFiles = lib.mergeAttrsList (lib.mapAttrsToList namesForShard (builtins.readDir baseDirectory));
    te = file: pkgs.callPackage file {};
in
{
    forgeServers = pkgs.callPackage ./forgeServers/. {};
    fetchModrinthModpack = pkgs.callPackage ./fetchModrinthModpack.nix {};

    death = lib.mapAttrs (name: te) packageFiles;
}
