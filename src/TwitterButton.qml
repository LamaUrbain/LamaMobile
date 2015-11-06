import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Controls.Button {
    property int itineraryId: -1
    source: Constants.LAMA_TWITTER_RESSOURCE
    onClicked: Qt.openUrlExternally(Constants.LAMA_URL_TWITTER_SHARE + itineraryId + Constants.LAMA_URL_TWITTER_HASHTAGS);
}
