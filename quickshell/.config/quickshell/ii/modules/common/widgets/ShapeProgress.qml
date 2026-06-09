import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property int shape: MaterialShape.Shape.Circle
    property real value: 0
    property color colPrimary: Appearance?.colors.colOnSecondaryContainer ?? "#685496"
    property color colSecondary: Appearance?.colors.colSecondaryContainer ?? "#F1D3F9"
    property int implicitSize: 20

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    // 1. Muted Background Track Shape
    MaterialShape {
        id: bgShape
        anchors.fill: parent
        color: root.colSecondary
        shape: root.shape
    }

    // 2. Active Filled Shape (Clipped Vertically to show Progress value)
    Item {
        id: fillClipContainer
        width: parent.width
        height: parent.height * Math.max(0.0, Math.min(1.0, root.value))
        anchors.bottom: parent.bottom
        clip: true

        MaterialShape {
            id: fgShape
            width: root.implicitSize
            height: root.implicitSize
            anchors.bottom: parent.bottom
            color: root.colPrimary
            shape: root.shape
        }
    }
}
