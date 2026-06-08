pragma Singleton
import qs.modules.common
import QtQuick
import QtCore  
import Quickshell
import Quickshell.Wayland

/**
 * A nice wrapper for date and time strings.
 */
Singleton {
    id: root

    property alias inhibit: idleInhibitor.enabled
    // inhibit: false

    Settings {
        id: settings
        property bool savedInhibit: false
    }

    Component.onCompleted: {
        root.inhibit = settings.savedInhibit
    }

    Connections {
        target: Persistent
        function onReadyChanged() {
            Persistent.states.idle.inhibit = root.inhibit
        }
    }

    function toggleInhibit(active = null) {
        if (active !== null) {
            root.inhibit = active;
        } else {
            root.inhibit = !root.inhibit;
        }

        settings.savedInhibit = root.inhibit
        Persistent.states.idle.inhibit = root.inhibit
    }

    IdleInhibitor {
        id: idleInhibitor
        enabled: false 
        window: PanelWindow {
            // Inhibitor requires a "visible" surface
            // Actually not lol
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"
            // Just in case...
            anchors {
                right: true
                bottom: true
            }
            // Make it not interactable
            mask: Region {
                item: null
            }
        }
    }
}
