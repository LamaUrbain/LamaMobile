import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtLocation 5.3
import QtPositioning 5.3
import QtGraphicalEffects 1.0
import "qrc:/Components" as Components
import "qrc:/Controls" as Controls
import "qrc:/Constants.js" as Constants

Controls.MapItem {
    id: popover
    sourceItem: popoverItem

    signal setDepartureRequest();
    signal addDestinationRequest();
    signal setDestinationRequest();

    property alias address: addressArea.text
    property alias street: streetArea.text
    property alias city: cityArea.text

    function getText(coords)
    {
        return Number(coords.y).toFixed(6) + ", " + Number(coords.x).toFixed(6);
    }

    Item {
        id: popoverItem
        width: 335
        height: background.height + arrow.height

        MouseArea {
            anchors.fill: parent
            onClicked: focus = true;
            onWheel: wheel.accepted = true;
            preventStealing: true
        }

        RectangularGlow {
            anchors.fill: background
            glowRadius: 12
            spread: 0.2
            color: "#55000000"
            cornerRadius: background.radius + glowRadius
        }

        Rectangle {
            id: background
            color: "white"
            border.width: 1
            border.color: "#33000000"
            radius: 6
            height: inner.height + 20
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: arrow.width
                color: "white"
                height: 1
            }

            Column {
                id: inner
                spacing: 14
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: 2
                }

                Item {
                    height: 40
                    clip: true
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 2
                        rightMargin: 2
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: -5
                        color: "#F0F0F0"
                        radius: 5
                    }

                    Rectangle {
                        height: 1
                        color: "#E0E0E0"
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }

                    Components.TextLabel {
                        id: addressArea
                        elide: Text.ElideRight
                        font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
                        font.bold: true
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: 14
                            rightMargin: 14
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Item {
                    height: Math.max(descriptionArea.height, actionsArea.height)
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 14
                        rightMargin: 14
                    }

                    Column {
                        id: descriptionArea
                        spacing: 3
                        anchors {
                            left: parent.left
                            right: actionsArea.left
                            rightMargin: 10
                            verticalCenter: parent.verticalCenter
                        }

                        Components.TextLabel {
                            id: streetArea
                            visible: text != ""
                            elide: Text.ElideRight
                            font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }

                        Components.TextLabel {
                            id: cityArea
                            visible: text != ""
                            elide: Text.ElideRight
                            font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }

                        Components.TextLabel {
                            text: getText(popover.coordinate)
                            elide: Text.ElideRight
                            font.pixelSize: Constants.LAMA_PIXELSIZE_SMALL - 2
                            opacity: 0.6
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }
                    }

                    RowLayout {
                        id: actionsArea
                        spacing: 10
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        Controls.ImageButton {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 54
                            source: Constants.LAMA_DEPARTURE_RESSOURCE
                            onClicked: popover.setDepartureRequest();
                        }

                        Controls.ImageButton {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 54
                            source: Constants.LAMA_INDICATOR_RESSOURCE
                            onClicked: popover.addDestinationRequest();
                        }

                        Controls.ImageButton {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 54
                            source: Constants.LAMA_ARRIVAL_RESSOURCE
                            onClicked: popover.setDestinationRequest();
                        }
                    }
                }
            }
        }

        Canvas {
            id: arrow
            width: 20
            height: 11
            antialiasing: true
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            onPaint: {
                var ctx = getContext("2d");

                ctx.save();
                ctx.clearRect(0, 0, arrow.width, arrow.height);
                ctx.strokeStyle = "#33000000";
                ctx.lineWidth = 1;
                ctx.fillStyle = "#FFFFFF";
                ctx.globalAlpha = 1.0;
                ctx.lineJoin = "round";
                ctx.beginPath();

                ctx.moveTo(0, 0);
                ctx.lineTo(arrow.width, 0);
                ctx.lineTo(arrow.width / 2, arrow.height);

                ctx.closePath();
                ctx.fill();
                ctx.beginPath();

                ctx.moveTo(0, 0);
                ctx.lineTo(arrow.width / 2, arrow.height);
                ctx.lineTo(arrow.width, 0);

                ctx.stroke();
                ctx.restore();
            }
        }
    }
}
