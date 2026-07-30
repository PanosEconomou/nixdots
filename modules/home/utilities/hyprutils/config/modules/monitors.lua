-- Monitor and display config
local monitor   = hl.monitor

local internal  = {
    output      = "eDP-1",
    mode        = "preferred",
    position    = "0x0",
    scale       = 1,
    disabled    = false,
}

-- Set up primary display
monitor(internal)

-- Set up external displays above the main one
monitor({
    output      = "DP-1",
    mode        = "highres",
    position    = "0x-1080",
    scale       = 1,
})

-- the rest
monitor({
    output      = "",
    mode        = "highres",
    position    = "auto",
    scale       = 1,
})

return internal
