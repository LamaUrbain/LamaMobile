import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Constants.js" as Constants

Components.MarkerInput {
    height: primary ? 50 : 30
    implicitHeight: primary ? 50 : 30

    signal navButtonPressed();

    property string source: ""
    property string text: ""
    property string navigationTarget
    property var navigationTargetProperties
    property bool acceptClick: true
    property bool replace: false
    property bool primary: true

    function navigate()
    {
        if (acceptClick && navigationTarget)
            rootView.mainViewTo(navigationTarget, replace, navigationTargetProperties);
    }

    onClicked:
    {
        // needed to raise a second signal, else you can't pretreat stuff
        navButtonPressed();
        navigate();
    }

    Components.TextLabel {
        text: parent.text
        color: "#FFF"
        font.pixelSize: primary ? Constants.LAMA_PIXELSIZE : Constants.LAMA_PIXELSIZE_MEDIUM
        anchors.centerIn: parent
    }

    Image {
        width: primary ? 28 : 20
        height: primary ? 28 : 20
        mipmap: true
        source: parent.source
        fillMode: Image.PreserveAspectFit
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 15
        }
    }
}
