import QtQuick 2.5
import "qrc:/Constants.js" as Constants

Rectangle
{
    id: gravCanvas
    property string email: null
    property string pixelSize: Constants.LAMA_GRAVATAR_SIZE

    Image
    {
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        Component.onCompleted:
        {
            if (gravCanvas.email !== null && gravCanvas.email.length > 0)
                source = Constants.LAMA_GRAVATAR_URL + Qt.md5(gravCanvas.email)
                        + Constants.LAMA_GRAVATAR_EXT
                        + "?s=" + gravCanvas.pixelSize
            else
                source = Constants.LAMA_PROFILE_RESSOURCE;
        }
    }
}

