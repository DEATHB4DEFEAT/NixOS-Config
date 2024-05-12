{
    programs = {
        bash = {
            enable = true;
            shellAliases = {
                reconf = "sudo nixos-rebuild switch --flake '/home/death/setup#DTLinix'";
            };
        };
    };
}
