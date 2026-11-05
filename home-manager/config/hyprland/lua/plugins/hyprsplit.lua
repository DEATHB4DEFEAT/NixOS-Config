if not hs then
    return
end

hs.config({
    num_workspaces = 5,
    persistent_workspaces = false,
})

for i = 1, 5 do
    local key = i % 10 -- 10 is 0
    hl.bind("SUPER + "..key, hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + "..key, hs.dsp.window.move({ workspace = i, follow = false }))
end
