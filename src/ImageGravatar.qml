import QtQuick 2.5
import "qrc:/Constants.js" as Constants

Item {
    id: gravCanvas
    width: pixelSize
    height: width

    property string email: null
    property int pixelSize: Constants.LAMA_GRAVATAR_SIZE

    Image {
        cache: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        Component.onCompleted: {
            if (gravCanvas.email !== null && gravCanvas.email.length > 0) {
                source = Constants.LAMA_GRAVATAR_URL
                        + Qt.md5(gravCanvas.email.toLowerCase())
                        + "?d=retro&s=" + gravCanvas.pixelSize;
            }
            else
                source = Constants.LAMA_PROFILE_RESSOURCE;
        }
    }
}
