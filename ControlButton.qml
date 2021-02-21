import QtQuick 2.14
import QtQuick.Controls 2.14

Button {
    id: m_base
    text: qsTr("text")
    hoverEnabled: true

    background: Rectangle{
        id: btnBkng

        implicitWidth: 106
        implicitHeight: 33
        color: "#1b1b40"
        border.width: 2
        border.color: "transparent"
        radius: 8
    }

    contentItem: Text {
        id: btnText
        text: m_base.text
        color: enabled ? "white" : Qt.darker("white", 1.5)

        font{
            family: "Montserrat Light"
            pixelSize: 20
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    onHoveredChanged:{
        if(hovered === true)
            btnBkng.border.color = "#ffffff"
        else
            btnBkng.border.color = "transparent"
    }

    onPressed: {
        btnBkng.color = Qt.darker("#1b1b40", 1.5)
        btnBkng.border.color = Qt.darker("white", 1.25)
        btnText.color = Qt.darker("white", 1.25)
    }

    onReleased:{
        btnBkng.color = "#1b1b40"
        btnBkng.border.color = "white"
        btnText.color = "white"
    }

    //For some Reason the binding to the text colour breaks, so I have to do this
    onEnabledChanged: btnText.color = enabled ? "white" : Qt.darker("white", 1.5)
}
