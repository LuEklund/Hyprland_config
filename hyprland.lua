-- Hyprland config, ported from hyprland.conf (kept as a fallback; lua wins if present).
-- hyprsplit is now a lua library, not a hyprpm plugin: ~/.config/hypr/hyprsplit/init.lua

local hs = require("hyprsplit")

----------------
-- MONITORS
----------------

hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })

----------------
-- PROGRAMS
----------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "killall -SIGUSR1 waybar; wofi --show drun --normal-window; killall -SIGUSR1 waybar" -- bar visible only while wofi is open

----------------
-- AUTOSTART
----------------

hl.on("hyprland.start", function()
    -- Wayland screenshare fix: export env to systemd/D-Bus and bring up the
    -- session target so graphical-session.target activates. Without this,
    -- xdg-desktop-portal (Requisite=graphical-session.target) refuses to start
    -- and Discord/OBS screen capture fails.
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")

    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon & awww img ~/.config/hypr/ArchLinuxBG.png")
    hl.exec_cmd("wayscriber --daemon")
    hl.exec_cmd("hyprctl keyword security allow_portal_screencast true")

    hl.exec_cmd("brave 'https://youtu.be/OdBjD4Da2Is?t=338' 'https://www.youtube.com/watch?v=ZI198eFghJk' 'https://box2d.org/posts/2024/08/determinism/#cross-platform-determinism'")
end)

----------------
-- ENVIRONMENT
----------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_DATA_DIRS", os.getenv("HOME") .. "/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share")

----------------
-- PERMISSIONS
----------------

hl.config({ ecosystem = { enforce_permissions = true } })

hl.permission("/usr/bin/hyprpicker", "screencopy", "allow")
hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/bin/grimblast", "screencopy", "allow")

----------------
-- HYPRSPLIT
----------------

hs.config({ num_workspaces = 5 })

----------------
-- LOOK AND FEEL
----------------

hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 1,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 0,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = { enabled = true, range = 4, render_power = 3, color = 0xee1a1a1a },
        blur   = { enabled = false, size = 3, passes = 1, vibrancy = 0.1696 },
    },

    animations = { enabled = false },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})

----------------
-- INPUT
----------------

hl.config({
    input = {
        kb_layout    = "fi,us",
        follow_mouse = 0,
        float_switch_override_focus = 0, -- mouse crossing floating<->tiled must not steal focus (wofi)
        sensitivity  = 0,
        touchpad     = { natural_scroll = false },
    },
})

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

----------------
-- KEYBINDINGS
----------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + M", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd(menu), { release = true })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("spotify-launcher"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Resize windows
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -80, relative = true }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 80, relative = true }))
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -80, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 80, y = 0, relative = true }))

-- Move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Swap windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Screenshot
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -zm region --clipboard"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -zm region --raw | swappy -f - -o ~/Pictures/screenshot-$(date +%F-%T).png"))

-- Record gif
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("kitty -d ~/Projects/gifer ./zig-out/bin/gifer"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkill -INT wf-recorder"))

-- Color picker
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))

-- Zoom
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pkill hyprmag || hyprmag"))

-- Draw on screen
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("pkill -SIGUSR1 wayscriber"))

-- Emoji
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("~/.config/hypr/scripts/emoji.sh"))

-- Per-monitor workspaces (hyprsplit)
for i = 1, 6 do
    hl.bind(mainMod .. " + " .. i, hs.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hs.dsp.window.move({ workspace = i, follow = false }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

----------------
-- WINDOW RULES
----------------

hl.window_rule({
    name             = "windowrule-1",
    match            = { class = "^(StreamFighter0\\.2\\.x86_64)$" },
    render_unfocused = true,
})

hl.window_rule({
    -- Ignore maximize requests from apps.
    name           = "windowrule-2",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "windowrule-3",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name     = "windowrule-4",
    match    = { title = "^(StreamerFighter)$" },
    no_focus = true,
})

hl.window_rule({
    -- wofi as a normal window so waybar stays clickable
    name   = "windowrule-wofi",
    match  = { class = "^(wofi)$" },
    float  = true,
    center = true,
})
