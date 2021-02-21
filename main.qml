import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: rootWindow
    visible: true
    width: 850
    height: 450
    title: qsTr("Timer")
    color: "transparent"

    // Removing the title Bar
    flags: Qt.FramelessWindowHint | Qt.Window

    // for interfacing with "timerface" backend
    signal stopwatchState()
    signal countdownState()


    WindowBase{
        id: base
        objectName: "base"

        anchors.fill: parent


        states: [
            State {
                name: "stopwatch"
                PropertyChanges {
                    target: countdownBtn
                    state: "normal"
                }

                PropertyChanges {
                    target: stopwatchBtn
                    state: "selected"
                }

                PropertyChanges {
                    target: timerFace
                    state: "uneditable"
                }
            },

            State {
                name: "countdown"
                PropertyChanges {
                    target: stopwatchBtn
                    state: "normal"
                }

                PropertyChanges {
                    target: countdownBtn
                    state: "selected"
                }

                // this property may be affected by another function in TimerFace
                PropertyChanges {
                    target: timerFace
                    state: "editable"
                }
            }
        ]

        state: "stopwatch"

        onStateChanged: {
            if(state === "stopwatch")
                rootWindow.stopwatchState()
            else if(state === "countdown")
                rootWindow.countdownState()

        }

        // Title Bar dragging
        MouseArea{
            id: dragBar
            width: parent.width-50
            height: 25

            anchors{
                left: parent.left
                top:parent.top

            }

            property int prevX
            property int prevY

            onPressed: {
                prevX = mouseX
                prevY = mouseY
            }

            onMouseXChanged: {
                if(pressed)
                    rootWindow.x = rootWindow.x + mouseX - prevX

            }

            onMouseYChanged: {
                if(pressed)
                    rootWindow.y = rootWindow.y + mouseY - prevY
            }
        }

        Text {
            id: titleBarText
            text: qsTr("Timer")
            color: "#ffffff"
            font{
                family: "Montserrat Medium"
                pixelSize: 13
            }

            anchors{
                top:parent.top
                left: parent.left
                topMargin: 7
                leftMargin: 11
            }
        }

        // minimize the window
        minimizeBtn.onClicked: {
            rootWindow.showMinimized()
        }

        SelectionButton{
            id: stopwatchBtn

            state: "selected"

            anchors{
                top: parent.top
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -220
            }

            text: "Stopwatch"


            onSelected: base.state = "stopwatch"
        }

        SelectionButton{
            id: countdownBtn

            state: "normal"

            anchors{
                top: parent.top
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 220
            }

            text: "Countdown"


            onSelected: base.state = "countdown"
        }

        TimerFace{
            id: timerFace
            objectName: "timerFace"

            width: 498
            height: 174

            anchors.centerIn: parent
            anchors.verticalCenterOffset: -35
        }

        ControlPanel{
            id: controlPanel
            objectName: "controlPanel"

            width: 400
            height: 60

            anchors{
                verticalCenterOffset: 103
                horizontalCenterOffset: 0
                centerIn: parent
            }
        }
    }
}
