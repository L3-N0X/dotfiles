import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.synchronizer
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope { // Scope
    id: root

    Loader {
        id: macroCheatsheetLoader
        active: false

        sourceComponent: PanelWindow { // Window
            id: macroCheatsheetRoot
            visible: macroCheatsheetLoader.active

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            function hide() {
                macroCheatsheetLoader.active = false;
            }
            exclusiveZone: 0
            implicitWidth: macroCheatsheetBackground.width + Appearance.sizes.elevationMargin * 2
            implicitHeight: macroCheatsheetBackground.height + Appearance.sizes.elevationMargin * 2
            WlrLayershell.namespace: "quickshell:macroCheatsheet"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            color: "transparent"

            mask: Region {
                item: macroCheatsheetBackground
            }

            Component.onCompleted: {
                GlobalFocusGrab.addDismissable(macroCheatsheetRoot);
            }
            Component.onDestruction: {
                GlobalFocusGrab.removeDismissable(macroCheatsheetRoot);
            }
            Connections {
                target: GlobalFocusGrab
                function onDismissed() {
                    macroCheatsheetRoot.hide();
                }
            }

            // Background
            StyledRectangularShadow {
                target: macroCheatsheetBackground
            }
            Rectangle {
                id: macroCheatsheetBackground
                anchors.centerIn: parent
                color: Appearance.colors.colLayer0
                border.width: 1
                border.color: Appearance.colors.colLayer0Border
                radius: Appearance.rounding.windowRounding
                property real padding: 20
                implicitWidth: macroCheatsheetColumnLayout.implicitWidth + padding * 2
                implicitHeight: macroCheatsheetColumnLayout.implicitHeight + padding * 2

                Keys.onPressed: event => { // Esc to close
                    if (event.key === Qt.Key_Escape) {
                        macroCheatsheetRoot.hide();
                    }
                    if (event.modifiers === Qt.ControlModifier) {
                        if (event.key === Qt.Key_PageDown) {
                            tabBar.incrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_PageUp) {
                            tabBar.decrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Tab) {
                            tabBar.setCurrentIndex((tabBar.currentIndex + 1) % MacroKeyboardLayers.layers.length);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Backtab) {
                            tabBar.setCurrentIndex((tabBar.currentIndex - 1 + MacroKeyboardLayers.layers.length) % MacroKeyboardLayers.layers.length);
                            event.accepted = true;
                        }
                    }
                }

                RippleButton { // Close button
                    id: closeButton
                    focus: macroCheatsheetRoot.visible
                    implicitWidth: 40
                    implicitHeight: 40
                    buttonRadius: Appearance.rounding.full
                    anchors {
                        top: parent.top
                        right: parent.right
                        topMargin: 20
                        rightMargin: 20
                    }

                    onClicked: {
                        macroCheatsheetRoot.hide();
                    }

                    contentItem: MaterialSymbol {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Appearance.font.pixelSize.title
                        text: "close"
                    }
                }

                ColumnLayout { // Real content
                    id: macroCheatsheetColumnLayout
                    anchors.centerIn: parent
                    spacing: 10

                    Toolbar {
                        Layout.alignment: Qt.AlignHCenter
                        enableShadow: false
                        ToolbarTabBar {
                            id: tabBar
                            tabButtonList: MacroKeyboardLayers.layers.map(layer => ({
                                "icon": "dialpad",
                                "name": layer.name
                            }))

                            Synchronizer on currentIndex {
                                property alias source: swipeView.currentIndex
                            }
                        }
                    }

                    SwipeView { // Content pages
                        id: swipeView
                        Layout.topMargin: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10
                        currentIndex: Persistent.states.macroCheatsheet.tabIndex
                        onCurrentIndexChanged: {
                            Persistent.states.macroCheatsheet.tabIndex = currentIndex;
                        }

                        implicitWidth: Math.max.apply(null, contentChildren.map(child => child.implicitWidth || 0))
                        implicitHeight: Math.max.apply(null, contentChildren.map(child => child.implicitHeight || 0))

                        clip: true
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: swipeView.width
                                height: swipeView.height
                                radius: Appearance.rounding.small
                            }
                        }

                        Repeater {
                            model: MacroKeyboardLayers.layers
                            delegate: MacroCheatsheetLayer {
                                required property var modelData
                                layerData: modelData
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "macroCheatsheet"

        function toggle(): void {
            macroCheatsheetLoader.active = !macroCheatsheetLoader.active;
        }

        function close(): void {
            macroCheatsheetLoader.active = false;
        }

        function open(): void {
            macroCheatsheetLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "macroCheatsheetToggle"
        description: "Toggles macro keyboard cheatsheet on press"

        onPressed: {
            macroCheatsheetLoader.active = !macroCheatsheetLoader.active;
        }
    }

    GlobalShortcut {
        name: "macroCheatsheetOpen"
        description: "Opens macro keyboard cheatsheet on press"

        onPressed: {
            macroCheatsheetLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "macroCheatsheetClose"
        description: "Closes macro keyboard cheatsheet on press"

        onPressed: {
            macroCheatsheetLoader.active = false;
        }
    }
}
