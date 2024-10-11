{
    wayland.windowManager.hyprland = {
        settings = {
            bind =
                [
                    "SUPER, F, exec, firefox"
                    "SUPER, RETURN, exec, foot"
                    "SUPER, E, exec, dolphin"
                    "SUPER, Q, killactive"
                    "SUPER, L, exec, hyprctl dispatch exit"
                    "SUPER, R, exec, hyprctl reload"
                ]
                ++ (
                    # Workspaces
                    # Binds SUPER + [shift +] {1..10} to [move to] workspace {1..10}
                    builtins.concatLists (
                        builtins.genList (
                            x:
                                let ws =
                                    let c = (x + 1) / 10;
                                    in builtins.toString (x + 1 - (c * 10));
                            in
                            [
                                "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                                "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                            ]
                        ) 10
                    )
                );
        };
    };
}
