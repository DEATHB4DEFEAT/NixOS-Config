{
    pkgs,
    ...
}:

{
    services = {
        gpg-agent = {
            pinentryPackage = pkgs.pinentry-curses;
            defaultCacheTtl = 1800;
            enableSshSupport = true;
        };
    };

    programs = {
        gpg = {
            enable = true;
            mutableKeys = true;
            mutableTrust = true;
        };
    };
}
