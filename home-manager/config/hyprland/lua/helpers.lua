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

---@param binds [string, HL.Dispatcher, table][]
function BIND_ALL(binds)
    for _, bind in ipairs(binds) do
        hl.bind(bind[1], bind[2], bind)
    end
end

---@diagnostic disable-next-line: lowercase-global
hs = require("lua/hyprsplit")
