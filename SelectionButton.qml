import QtQuick 2.14

Rectangle {
    id: m_base

    width: 160
    height: 35

    signal selected()

    property alias text: btnText.text

    color: "#090923"
    border.color: "transparent"
    border.width: 2
    radius: 7

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: m_base
                border.color: "transparent"
            }
        },

        State {
            name: "hovered"
            PropertyChanges {
                target: m_base
                border.color: Qt.darker("#b3b3b3", 1.5)

            }
        },

        State {
            name: "selected"
            PropertyChanges {
                target: m_base
                border.color: "#b3b3b3"

            }
        }
    ]

    Text {
        id: btnText
        text: qsTr("Text")
        color: "white"
        anchors.centerIn: parent

        font{
            family: "Montserrat Medium"
            pixelSize: 17
        }
    }

    MouseArea{
        id: selectionBtnMA

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if(m_base.state != "selected")
                m_base.state =  "hovered"
        }
        onExited: {
            if(m_base.state != "selected")
                m_base.state =  "normal"
        }

        onClicked: {
            m_base.state = "selected"
            selected()
        }
    }
}


