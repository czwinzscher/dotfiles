hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("/usr/bin/waybar")
    hl.exec_cmd("/usr/bin/nm-applet")
    hl.exec_cmd("/usr/bin/nextcloud --background")
    hl.exec_cmd("/usr/bin/cryptomator")
    hl.exec_cmd("/usr/bin/hyprsunset")
    hl.exec_cmd("[workspace 6 silent] spotify")
    hl.exec_cmd("discord", { workspace = "5 silent" })
    hl.exec_cmd("[workspace 4 silent] lutris")
    hl.exec_cmd("[workspace 3 silent] thunderbird")
    hl.exec_cmd("[workspace 2 silent] element-desktop")
    hl.exec_cmd("[workspace 1] firefox")
end)

hl.config({
    input = {
        kb_layout = "de",
        kb_variant = "neo",
        repeat_delay = 200,
    }
})

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 0,
        border_size = 2,
        col = {
            active_border = "rgba(00ff99ee)",
        },
        layout = "dwindle",
    }
})

hl.config({
    decoration = {
        rounding = 1,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },
})

hl.config({
    animations = {
        enabled = false,
    },
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
    },
})

hl.config({
    dwindle = {
        force_split = 2,
        -- preserve_split = true,
    },
})

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

local mainMod = "SUPER"

hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("vicinae toggle"), { release = true })
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- bind = $mainMod, M, exit,
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("swaylock -f --color 404040"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("swaylock -f --color 404040 ; systemctl suspend"))
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("Print",
    hl.dsp.exec_cmd(
        "grim - | satty --filename - --action-on-enter save-to-clipboard --early-exit --copy-command wl-copy"))
hl.bind(mainMod .. " + Print",
    hl.dsp.exec_cmd(
        "grim -g \"$(slurp)\" - | satty --filename - --action-on-enter save-to-clipboard --early-exit --copy-command wl-copy"))
hl.bind(mainMod .. "+ L", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness ctl set +5%"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))

hl.bind(mainMod .. " + n", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + d", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + t", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + r", hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + SHIFT + nrtd
hl.bind(mainMod .. " + SHIFT + n", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + d", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + r", hl.dsp.window.move({ direction = "down" }))

for i = 1, 10 do
    hl.bind(mainMod .. " + " .. (i % 10), hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i }))
end

-- Switch to next/previous workspace with mainMod + Tab
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))

-- Switch to next empty workspace with mainMod + g
hl.bind(mainMod .. " + g", hl.dsp.focus({ workspace = "empty" }))
hl.bind(mainMod .. " + SHIFT + g", hl.dsp.window.move({ workspace = "empty" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
