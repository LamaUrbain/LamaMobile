import QtQuick 2.0
import "qrc:/Components/" as Components

Button {
    property string navigationTarget
    property var navigationTargetProperties
    property bool acceptClick: true
    signal navButtonPressed()
    function navigate()
    {
        if (acceptClick === true)
            rootView.mainViewTo(navigationTarget, navigationTargetProperties)
    }

    onClicked:
    {
        navButtonPressed() // needed to raise a second signal, else you can't pretreat stuff
        navigate()
    }
}
