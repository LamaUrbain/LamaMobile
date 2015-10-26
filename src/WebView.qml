import QtQuick 2.0
import QtWebKit 3.0
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls
import "qrc:/Constants.js" as Constants

Components.Background
{
    property alias webUrl: webview.url

    Components.Header {
        id: header
        title: "Partage"
    }

    WebView
    {
        id: webview
        url: Constants.LAMA_DEFAULT_URL
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}

