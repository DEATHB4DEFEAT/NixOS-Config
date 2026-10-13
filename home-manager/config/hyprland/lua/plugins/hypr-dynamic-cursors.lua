if hl.plugin.dynamic_cursors then
    hl.config{
        plugin = {
            dynamic_cursors = {
                enabled = true,
                mode = "stretch",
                threshold = 2,
                stretch = {
                    limit = 3000,
                    activation = "quadratic",
                },
                shake = {
                    enabled = false,
                },
            },
        },
    }
end
