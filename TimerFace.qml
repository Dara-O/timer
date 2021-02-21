import QtQuick 2.14
import QtQuick.Controls 1.4

Rectangle {
    id: m_base

    width: 498
    height: 174

    color: "#090923"

    // To tell the Backend that the time has been editted by the user
    signal timeEdited(string hour, string min, string sec)

    // To receive time updates from the Backend
    function updateTime(hour: string, min: string, sec: string) {
        if(hour.length === 2){
            hourDisplay.text = hour
        }

        if(min.length === 2){
            minDisplay.text = min
        }

        if(sec.length === 2){
            secDisplay.text = sec
        }
    }

    // these functinos also affect the state and are called from the backend (timerinterface)
    function makeEditable(){
        state = "editable"
    }

    function makeUneditable(){
        state = "uneditable"
    }

    function arrowUpIncrement(time: string){

        return (Number(time) + 1).toString()
    }

    function arrowDownDecrement(time: string){
        if (Number(time) !== 0)
        {
            return (Number(time) - 1).toString()
        }
        else
            return 0

    }

    states:[
        State {
            name: "uneditable"
            PropertyChanges {
                target: hourDisplay
                readOnly: true
            }

            PropertyChanges {
                target: minDisplay
                readOnly: true
            }

            PropertyChanges {
                target: secDisplay
                readOnly: true
            }

            PropertyChanges {
                target: hourDisplay
                activeFocusOnPress: false
            }

            PropertyChanges {
                target: minDisplay
                activeFocusOnPress: false
            }

            PropertyChanges {
                target: secDisplay
                activeFocusOnPress: false
            }
        },

        State {
            name: "editable"
            PropertyChanges {
                target: hourDisplay
                readOnly: false
            }

            PropertyChanges {
                target: minDisplay
                readOnly: false
            }

            PropertyChanges {
                target: secDisplay
                readOnly: false
            }

            PropertyChanges {
                target: hourDisplay
                activeFocusOnPress: true
            }

            PropertyChanges {
                target: minDisplay
                activeFocusOnPress: true
            }

            PropertyChanges {
                target: secDisplay
                activeFocusOnPress: true
            }

            PropertyChanges {
                target: secDisplay
                focus: true
                cursorPosition: 1
            }
        }
    ]

    TextInput {
        id: hourDisplay
        text: qsTr("00")
        color: "white"
        width: 130
        maximumLength: 2
        anchors{
            left: parent.left
            leftMargin: 20
            top: parent.top
            topMargin: 10
        }

        font{
            family: "Montserrat Light"
            pixelSize: 99
        }

        onEditingFinished: timeEdited(hourDisplay.text, minDisplay.text, secDisplay.text)

        Keys.onPressed: {
            if(event.key === Qt.Key_Right && cursorPosition === hourDisplay.text.length)
            {
                minDisplay.focus = true
                minDisplay.cursorPosition = 0;
            }

            if(event.key === Qt.Key_Up)
            {
                text = arrowUpIncrement(text)
            }

            if(event.key === Qt.Key_Down)
            {
                text = arrowDownDecrement(text)
            }
        }

        onFocusChanged: {
            focus ? selectAll() : null
        }
    }

    Text {
        id: colon1
        text: qsTr(":")

        color: "white"

        anchors{
            left: hourDisplay.right
            leftMargin: 8
            top: parent.top
            topMargin: 4
        }

        font{
            family: "Montserrat Light"
            pixelSize: 99
        }

    }

    TextInput {
        id: minDisplay
        text: qsTr("00")

        color: "white"

        width: 130
        maximumLength: 2

        anchors{
            left: colon1.right
            leftMargin: 8
            top: parent.top
            topMargin: 10
        }

        font{
            family: "Montserrat Light"
            pixelSize: 99
        }

        onEditingFinished: timeEdited(hourDisplay.text, minDisplay.text, secDisplay.text)

        Keys.onPressed: {
            if(event.key === Qt.Key_Left && cursorPosition === 0)
            {
                hourDisplay.focus = true
                hourDisplay.cursorPosition = 2;
            }

            if(event.key === Qt.Key_Right && cursorPosition === minDisplay.text.length)
            {
                secDisplay.focus = true
                secDisplay.cursorPosition = 0;
            }

            if(event.key === Qt.Key_Up)
            {
                text = arrowUpIncrement(text)
            }

            if(event.key === Qt.Key_Down)
            {
                text = arrowDownDecrement(text)
            }
        }

        onFocusChanged: {
            focus ? selectAll() : null
        }
    }

    Text {
        id: colon2
        text: qsTr(":")

        color: "white"

        anchors{
            left: minDisplay.right
            leftMargin: 8
            top: parent.top
            topMargin: 4
        }

        font{
            family: "Montserrat Light"
            pixelSize: 99
        }
    }

    TextInput {
        id: secDisplay
        text: qsTr("00")

        color: "white"

        width: 130
        maximumLength: 2

        anchors{
            left: colon2.right
            leftMargin: 8
            top: parent.top
            topMargin: 10
        }

        font{
            family: "Montserrat Light"
            pixelSize: 99
        }

        onEditingFinished: timeEdited(hourDisplay.text, minDisplay.text, secDisplay.text)

        Keys.onPressed: {
            if(event.key === Qt.Key_Left && cursorPosition === 0)
            {
                minDisplay.focus = true
                minDisplay.cursorPosition = 2;
            }

            // Arrow keys can change the time
            if(event.key === Qt.Key_Up)
            {
                text = arrowUpIncrement(text)
            }

            if(event.key === Qt.Key_Down)
            {
                text = arrowDownDecrement(text)
            }
        }

        onFocusChanged: {
            focus ? selectAll() : null
        }
    }

    Text {
        id: hourLbl

        anchors{
            top: hourDisplay.bottom
            topMargin: -2

            horizontalCenter: hourDisplay.horizontalCenter
        }

        color: "#ffffff"
        text: qsTr("Hour")
        font.family: "Montserrat Light"
        font.pixelSize: 15
    }

    Text {
        id: minLbl

        anchors{
            top: minDisplay.bottom
            topMargin: -2

            horizontalCenter: minDisplay.horizontalCenter
        }

        color: "#ffffff"
        text: qsTr("Min")
        font.family: "Montserrat Light"
        font.pixelSize: 15
    }

    Text {
        id: secLbl

        anchors{
            top: secDisplay.bottom
            topMargin: -2

            horizontalCenter: secDisplay.horizontalCenter
        }

        color: "#ffffff"
        text: qsTr("Sec")
        font.family: "Montserrat Light"
        font.pixelSize: 15
    }
}
