pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    required property var layerData

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 30

        GridLayout {
            id: keyGrid
            Layout.alignment: Qt.AlignVCenter
            columns: 4
            rowSpacing: 10
            columnSpacing: 10

            Repeater {
                model: root.layerData.grid
                delegate: Item {
                    id: cell
                    required property var modelData
                    Layout.preferredWidth: 96
                    Layout.preferredHeight: 96

                    MacroKeyCell {
                        anchors.fill: parent
                        visible: cell.modelData !== null
                        keyLabel: cell.modelData?.key ?? ""
                        description: cell.modelData?.desc ?? ""
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 12

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: "Rotary encoder"
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: Font.DemiBold
            }
            MacroEncoderRow {
                symbol: "rotate_left"
                actionLabel: "Left"
                description: root.layerData.encoder.left
            }
            MacroEncoderRow {
                symbol: "rotate_right"
                actionLabel: "Right"
                description: root.layerData.encoder.right
            }
            MacroEncoderRow {
                symbol: "radio_button_checked"
                actionLabel: "Click"
                description: root.layerData.encoder.click
            }
        }
    }

    component MacroKeyCell: Rectangle {
        id: keyCell
        property string keyLabel: ""
        property string description: ""

        radius: Appearance.rounding.small
        color: Appearance.colors.colLayer1
        border.width: 1
        border.color: Appearance.colors.colOutlineVariant

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                font.family: Appearance.font.family.monospace
                font.pixelSize: Appearance.font.pixelSize.normal
                font.weight: Font.DemiBold
                text: keyCell.keyLabel.length > 0 ? keyCell.keyLabel : "?"
            }
            StyledText {
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colOnLayer1
                text: keyCell.description
            }
        }
    }

    component MacroEncoderRow: RowLayout {
        id: encoderRow
        required property string symbol
        required property string actionLabel
        property string description: ""
        spacing: 8

        MaterialSymbol {
            text: encoderRow.symbol
            iconSize: Appearance.font.pixelSize.large
        }
        ColumnLayout {
            spacing: 0
            StyledText {
                font.pixelSize: Appearance.font.pixelSize.smaller
                font.weight: Font.DemiBold
                text: encoderRow.actionLabel
            }
            StyledText {
                Layout.preferredWidth: 130
                wrapMode: Text.WordWrap
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colOnLayer1
                text: encoderRow.description
            }
        }
    }
}
