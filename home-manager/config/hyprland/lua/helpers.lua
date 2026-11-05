---@param text string
function PRINT(text)
    hl.notification.create{
        text = ": "..text,
        timeout = 10000,
        color = "#FF0000",
    }
end

---@param cmds (string | [string, table<string, string|number|boolean>])[]
function EXEC_ALL(cmds)
    for _, cmd in ipairs(cmds) do
        if (type(cmd) == "string") then
            hl.exec_cmd(cmd)
        elseif (type(cmd) == "table") then
            hl.exec_cmd(table.unpack(cmd))
        else
            error("Can't exec type: "..type(cmd))
        end
    end
end

---@param rules HL.WindowRuleSpec[]
function WINDOW_RULES(rules)
    for _, rule in ipairs(rules) do
        hl.window_rule(rule)
    end
end

---@param curves [ string, { type: string, points: table<[ number, number ], [number, number]> } ][]
function CURVE_ALL(curves)
    for _, curve in ipairs(curves) do
        hl.curve(curve[1], curve[2])
    end
end

---@param animations ({ enabled: boolean, leaf: string, speed: number, bezier: string, style?: string } | { enabled: boolean, leaf: string, speed: number, spring: string, style?: string })[]
function ANIMATION_ALL(animations)
    for _, animation in ipairs(animations) do
        hl.animation(animation)
    end
end

---@param binds [string, HL.Dispatcher, table][]
function BIND_ALL(binds)
    for _, bind in ipairs(binds) do
        hl.bind(bind[1], bind[2], bind)
    end
end

local ok, module = pcall(require, "lua/hyprsplit")
hs = ok and module or nil ---@diagnostic disable-line: lowercase-global
