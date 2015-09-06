import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    width: 640
    height: 460
    visible: true

    Rectangle {
        anchors.fill: parent

        Column {
            spacing: 5

            TextInput {
                id: latitudeField
                width: 200
                height: 35

                Rectangle {
                    anchors.fill: parent
                    color: "grey"
                    opacity: 0.2
                    z: -1
                }
            }

            TextInput {
                id: longitudeField
                width: 200
                height: 35

                Rectangle {
                    anchors.fill: parent
                    color: "grey"
                    opacity: 0.2
                    z: -1
                }
            }

            Rectangle {
                width: 200
                height: 50
                color: "#C4C4C4C4"

                Text {
                    anchors.centerIn: parent
                    text: "Convert"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var callback = function(list)
                        {
                            geoCodingManager.addrFromCoordReceived.disconnect(callback);
                            var result = "";

                            for (var i = 0; i < list.length; ++i)
                                result += list[i] + " ";
                            resultText.text = result
                        }
                        geoCodingManager.addrFromCoordReceived.connect(callback);
                        var res = geoCodingManager.getAddrFromCoord(latitudeField.text, longitudeField.text)
                        console.log("Starting: " + res);
                    }
                }
            }

            Text {
                id: resultText
                text: ""
            }
        }
    }
}
