{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { } }:
    pkgs.mkShell {
        packages = with pkgs; [
            nixVersions.latest
            nixos-rebuild
        ];
    }

#? Try this first:
# nix-store --delete $(nix-store -q --referrers-closure /nix/store/path/to/derivation.drv)

#? Bypass nix daemon
# sudo systemctl stop nix-daemon.service; sudo nix build --store local --profile /nix/var/nix/profiles/system /home/death/.setup#nixosConfigurations.$(hostname).config.system.build.toplevel; sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch; sudo systemctl start nix-daemon.service
