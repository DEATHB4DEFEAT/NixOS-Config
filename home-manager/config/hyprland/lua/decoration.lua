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
            ---@diagnostic disable-next-line: assign-type-mismatch
            variant = "aurora",
            contrast = 1.1,
            noise = 0,
            passes = 3,
            size = 1,
            special = true,
            aurora = {
                intensity = 0.1,
            },
        },
        shadow = {
            enabled = true,
            range = 20,
            render_power = 3,
        },
        wobble = {
            enabled = true,
            stiffness = 300,
            damping = 7,
            intensity = 0.3,
        },
    },

    debug = { enable_stdout_logs = true, },
}

CURVE_ALL({
    {
        "linear",
        {
            type = "bezier",
            points = { {0, 0}, {1, 1} },
        },
    },
    {
        "somen",
        {
            type = "bezier",
            points = { {0.05, 0.9}, {0.1, 1.05} },
        },
    },
    {
        "easeInOutCubic",
        {
            type = "bezier",
            points = { {0.65, 0.05}, {0.36, 1} },
        },
    },
    {
        "easeOut",
        {
            type = "bezier",
            points = { {0.16, 1}, {0.3, 1} },
        },
    },
})

ANIMATION_ALL({
    {
        enabled = true,
        leaf = "windows",
        speed = 5,
        bezier = "somen",
    },
    {
        enabled = true,
        leaf = "windowsOut",
        speed = 5,
        bezier = "default",
        style = "popin 80%",
    },
    {
        enabled = true,
        leaf = "border",
        speed = 4,
        bezier = "linear",
    },
    {
        enabled = true,
        leaf = "borderangle",
        speed = 8,
        bezier = "easeInOutCubic",
    },
    {
        enabled = true,
        leaf = "fade",
        speed = 7,
        bezier = "default",
    },
    {
        enabled = true,
        leaf = "workspaces",
        speed = 5,
        bezier = "default",
        style = "slidevert",
    },
    {
        enabled = true,
        leaf = "zoomFactor",
        speed = 6,
        bezier = "easeOut",
    },
})
