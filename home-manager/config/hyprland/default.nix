{
    lib,
    pkgs,
    ...
}:

{
    imports = [
        ./keybinds.nix
        ./mousebinds.nix
    ];



    wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;

        extraConfig =
            let
                inherit (import ./variables.nix)
                    #browser #TODO
                    #terminal #TODO
                    keyboardLayout
                ;
        in
        ''
            # env = LIBVA_DRIVER_NAME=nvidia
            # env = GBM_BACKEND=nvidia-drm
            # env = __GLX_VENDOR_LIBRARY_NAME=nvidia
            env = WLR_NO_HARDWARE_CURSORS=1

            env = XDG_SESSION_TYPE=wayland
            env = ELECTRON_OZONE_PLATFORM_HINT=auto

            env = QT_QPA_PLATFORMTHEME=kde
            env = QT_QPA_PLATFORM=wayland
            env = XDG_MENU_PREFIX=plasma-

            env = PATH=$PATH:$HOME/.setup/home-manager/hyprland/scripts


            monitor = HDMI-A-2, 1920x1080@144, 0x0, 1
            monitor = DP-1, 3840x2160@60, 1920x0, 2


            input {
                follow_mouse = 1
                kb_layout = ${lib.concatStringsSep ", " keyboardLayout.layouts}
                kb_options = ${lib.concatStringsSep ", " keyboardLayout.options}
            }


            xwayland {
                force_zero_scaling = true
            }


            # exec-once = kstart plasmashell #TODO


            misc {
                middle_click_paste = false
            }
        '';
    };
}
