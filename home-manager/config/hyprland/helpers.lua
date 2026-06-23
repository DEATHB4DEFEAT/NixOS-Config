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
