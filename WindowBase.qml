import QtQuick 2.14
import QtQml 2.14

Rectangle {
    id: m_root

    property alias minimizeBtn: minimizeMA

    radius: 20
    color: "#090923"
    border{
        color: "#b3b3b3"
        width: 3
    }

    // To remove focus from objects
    MouseArea{
        id: changeFocusMa

        anchors.fill: parent
        onClicked: focus = true
    }

    Rectangle{
        id: close
        width: 18
        height: 18
        color: "transparent"
        anchors{
            right: parent.right
            rightMargin: 13
            top: parent.top
            topMargin: 10
        }


        Rectangle{
            id: x1

            anchors.centerIn: parent
            width: 15
            height: 2
            rotation: 45
            color: "#8a8a8a"
        }

        Rectangle{
            id: x2

            anchors.centerIn: parent
            width: 15
            height: 2
            rotation: 135
            color: "#8a8a8a"
        }
        MouseArea{
            id: closeMA

            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                x1.color = x2.color = "red"
            }

            onExited: {
                x1.color = x2.color = "#8a8a8a"
            }

            onClicked: Qt.quit()
        }
    }

    Rectangle{
        id: minimizeBase

        width: 13
        height: 13
        color: "transparent"

        anchors{
            right: close.left
            rightMargin: 7
            top: parent.top
            topMargin: 10
        }


        Rectangle{
            id: minimizeBar

            width: 13
            height: 2
            color: "#8a8a8a"
            anchors.centerIn: parent
        }

        MouseArea{
            id: minimizeMA
            anchors.fill: parent
            hoverEnabled: true

            onEntered: minimizeBar.color = "white"
            onExited: minimizeBar.color = "#8a8a8a"

        }
    }

}
