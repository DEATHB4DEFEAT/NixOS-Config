__require("lua/helpers")

local configs = {
    "plugins/hypr-dynamic-cursors",
    "plugins/split-monitor-workspaces",
    "decoration",
    "display",
    "input",
}

for _, file in ipairs(configs) do
    local status, value = pcall(require, "lua/"..file)
    if status then
        print("Loaded "..file..":", value)
    else
        print("Failed to load "..file..":", value)
    end
end


local envs = {
    -- LIBVA_DRIVER_NAME = "nvidia",
    -- GBM_BACKEND = "nvidia-drm",
    -- __GLX_VENDOR_LIBRARY_NAME = "nvidia",
    WLR_NO_HARDWARE_CURSORS = 1,

    XDG_SESSION_TYPE = "wayland",
    XDG_MENU_PREFIX = "plasma-",
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share",
    ELECTRON_OZONE_PLATFORM_HINT = "auto",

    QT_QPA_PLATFORM = "wayland",
    -- QT_QPA_PLATFORMTHEME = "qt6ct",
    -- QT_STYLE_OVERRIDE = "kvantum",
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1,

    PATH = os.getenv'PATH'..":$HOME/.setup/home-manager/config/hyprland/scripts:$HOME/.setup/home-manager/config/hyprland/rofi/scripts",

    XCURSOR_THEME = "catppuccin-macchiato-mauve-cursors",
    XCURSOR_SIZE = "24",
}

hl.on("hyprland.start", function()
    for env, var in pairs(envs) do
        hl.env(env, var)
    end
end)


hl.on("hyprland.start", function()
    EXEC_ALL{
        "hyprctl switchxkblayout all 1",
        "hyprlock",
        "kwalletd6",
        -- "ckb-next -b",
        { "sleep 10; pw-jack carla $HOME/.setup/home-manager/config/apps/config/carla.carxp", { workspace = "4 silent" } },
        -- { "vesktop", { workspace = "1 silent" } },
        { "equibop", { workspace = "1 silent" } },
        -- { "sleep 5; finamp", { workspace = "special:magic silent" } },
        { "feishin", { workspace = "special:magic silent" } },
    }
end)


hl.config{
    general = {
        -- layout = "dwindle",
        layout = "scrolling",
    },
    dwindle = {
        -- pseudotile = true,
        preserve_split = true,
    },
    scrolling = {
        column_width = 0.7,
        -- focus_fit_method = 0, -- 0 = center, 1 = fit
    },
    misc = {
        force_default_wallpaper = 0,
        -- disable_hyprland_logo = true, -- No wallpaper
        -- vfr = true,
        -- initial_workspace_tracking = 2,
    },
}

hl.workspace_rule{
    workspace = "special:magic",
    gaps_in = 10,
    gaps_out = 10,
}


WINDOW_RULES{
    {
        match = { title = "^()$", class = "^(steam)$", },
        stay_focused = true,
    },
    -- Fix plasmashell popups kinda
    {
        match = { class = "^(org.kde.plasmashell)$", },
        float = true,
        move = { "cursor_x-50%", "cursor_y-1%", }
    },
    -- Fix odd behaviors in Intellij IDEs
    --? Fix splash screen showing in weird places and prevent annoying focus takeovers
    {
        match = { class = "^(jetbrains-.*)$", title = "^(splash)$", float = true, },
        center = true,
        no_focus = true,
        border_size = 0,
    },
    --? Center popups/find windows
    {
        match = { class = "^(jetbrains-.*)$", title = "^()$", float = true, },
        center = true,
        stay_focused = true,
        border_size = 0,
    },
    --? Disable window flicker when autocomplete or tooltips appear
    {
        match = { class = "^(jetbrains-.*)$", title = "^(win.*)$", float = true, },
        no_focus = true,
    },
    -- Bigscreen
    {
        match = { tag = "bigscreen", },
        no_max_size = true,
        border_color = "rgb(9b59b6)",
    },

    {
        match = { title = "^(Nyasynth)$", },
        float = true,
    },
}
