pragma Singleton
import QtQuick
import Quickshell

/**
 * Hard-coded cheat sheet data for the 5-layer macro keyboard.
 *
 * The pad has 12 keys arranged in a "plus" shape: a 4x4 grid with the
 * 4 corners missing. `grid` below has 16 slots in row-major order
 * (4 columns x 4 rows) - the corner slots (indices 0, 3, 12, 15) must
 * stay `null`, the other 12 are { "key": "<label on the keycap>", "desc": "<what it does>" }.
 *
 * There's also a rotary encoder near the top right of the pad, described
 * separately by `encoder.left` / `encoder.right` / `encoder.click`.
 *
 * Fill in the "key" and "desc"/left/right/click strings for each layer below.
 */
Singleton {
    id: root
    property var layers: [
        {
            "name": "Layer 0",
            "grid": [
                null, { "key": "▶", "desc": "Music Play/Pause" }, { "key": "to 0", "desc": "go to layer 0" }, null,
                { "key": "⏮", "desc": "previous song" }, { "key": "◄", "desc": "skip left" }, { "key": "►", "desc": "skip right" }, { "key": "⏭", "desc": "next song" },
                { "key": "to 1", "desc": "go to layer 1" }, { "key": "to 2", "desc": "go to layer 2" }, { "key": "to 3", "desc": "go to layer 3" }, { "key": "to 4", "desc": "go to layer 4" },
                null, { "key": "info", "desc": "opens this cheat sheet" }, { "key": "Esc", "desc": "Escape" }, null
            ],
            "encoder": { "left": "Vol -", "right": "Vol +", "click": "⏹ Media stop" }
        },
        {
            "name": "Layer 1",
            "grid": [
                null, { "key": "⌘ 1", "desc": "" }, { "key": "to 0", "desc": "go to layer 0" }, null,
                { "key": "⌘ 2", "desc": "" }, { "key": "⌘ 3", "desc": "" }, { "key": "⌘ 4", "desc": "" }, { "key": "⌘ 5", "desc": "" },
                { "key": "⌘ 6", "desc": "" }, { "key": "⌘ 7", "desc": "" }, { "key": "⌘ 8", "desc": "" }, { "key": "⌘ 9", "desc": "" },
                null, { "key": "Shift", "desc": "" }, { "key": "⌘ Space", "desc": "Launcher" }, null
            ],
            "encoder": { "left": "Bright -", "right": "Bright +", "click": "⌘ + I" }
        },
        {
            "name": "Layer 2",
            "grid": [
                null, { "key": "", "desc": "" }, { "key": "", "desc": "" }, null,
                { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" },
                { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" },
                null, { "key": "", "desc": "" }, { "key": "", "desc": "" }, null
            ],
            "encoder": { "left": "", "right": "", "click": "" }
        },
        {
            "name": "Layer 3",
            "grid": [
                null, { "key": "", "desc": "" }, { "key": "", "desc": "" }, null,
                { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" },
                { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" },
                null, { "key": "", "desc": "" }, { "key": "", "desc": "" }, null
            ],
            "encoder": { "left": "", "right": "", "click": "" }
        },
        {
            "name": "Layer 4",
            "grid": [
                null, { "key": "", "desc": "" }, { "key": "", "desc": "" }, null,
                { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" },
                { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" }, { "key": "", "desc": "" },
                null, { "key": "", "desc": "" }, { "key": "", "desc": "" }, null
            ],
            "encoder": { "left": "", "right": "", "click": "" }
        }
    ]
}
