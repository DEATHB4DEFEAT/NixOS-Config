hl.config{
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
    },

    decoration = {
        rounding = 0,
        dim_inactive = true,
        dim_strength = 0.1,
        blur = {
            enabled = true,
            size = 7,
            passes = 2,
            vibrancy = 0.1696,
            new_optimizations = true,
        },
        shadow = {
            enabled = false,
            range = 5,
            render_power = 2,
        },
    },

    animations = {
        enabled = true,
        bezier = {
            "linear, 0, 0, 1, 1",
            "somen, 0.05, 0.9, 0.1, 1.05",
            "easeInOutCubic, 0.65, 0.05, 0.36, 1",
            "easeOut, 0.16, 1, 0.3, 1",
        },
        animation = {
            "windows, 1, 5, somen",
            "windowsOut, 1, 5, default, popin 80%",
            "border, 1, 4, linear",
            "borderangle, 1, 8, easeInOutCubic",
            "fade, 1, 7, default",
            "workspaces, 1, 6, default",
            "zoomFactor, 1, 6, easeOut",
        },
    },

    debug = { enable_stdout_logs = true, },
}
