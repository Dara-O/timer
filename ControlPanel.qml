import QtQuick 2.14
import QtQuick.Controls 2.14

Rectangle {
    id: m_base

    width: 400
    height: 120

    color: "transparent"

    signal start()
    signal continueTimer()
    signal pause()
    signal reset()

    function disableStart(){
        startPauseBtn.enabled = false
    }

    function enableStart(){
        startPauseBtn.enabled = true
    }

    function resetControlPanel(){
        startPauseBtn.state = "start"
    }

    ControlButton{
        id: startPauseBtn

        state: "start"


        anchors{
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -114
        }

        states: [
            State {
                name: "start"
                PropertyChanges {
                    target: startPauseBtn
                    text: "Start"
                }
            },

            State {
                name: "pause"
                PropertyChanges {
                    target: startPauseBtn
                    text: "Pause"
                }
            },

            State {
                name: "continue"
                PropertyChanges {
                    target: startPauseBtn
                    text: "Resume"
                }
            }
        ]

        onClicked: {
            if(startPauseBtn.state === "start")
            {
                start()
                startPauseBtn.state = "pause"
            }

            else if(startPauseBtn.state === "pause")
            {
                pause()
                startPauseBtn.state = "continue"
            }

            else if(startPauseBtn.state === "continue")
            {
                continueTimer()
                startPauseBtn.state = "pause"
            }

        }
    }

    ControlButton{
        id: resetBtn

        text: "Reset"

        anchors{
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 114
        }

        onClicked: {
            reset()
            resetControlPanel()
        }
    }
}
