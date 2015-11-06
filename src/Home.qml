import QtQuick 2.5
import "qrc:/Components/" as Components
import "qrc:/Controls/" as Controls

Item {
    Controls.MenuToggle {
        visible: !rootView.menuView.displayed
        onClicked: rootView.menuView.displayed = true;
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 30
            topMargin: 30
        }
    }

    Controls.ItineraryToggle {
        visible: !rootView.menuView.displayed && rootView.currentItinerary.id >= 0 ? 1 : 0
        onClicked: {
            var page = "MainSearchReadOnly";
            if (!rootView.currentItinerary.owner || rootView.session.username == rootView.currentItinerary.owner)
                page = "MainSearch";
            rootView.mainViewTo(page, false, null);
        }
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: 30
            topMargin: 22
        }
    }

    HomeSearch {
        anchors.centerIn: parent
        visible: opacity > 0
        opacity: !rootView.menuView.displayed && rootView.currentItinerary.id < 0 ? 1 : 0
        onSearchRequest: {
            if (departure)
                rootView.homeSearch(departure);
        }

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Controls.HomeButton {
        visible: !rootView.menuView.displayed && rootView.currentItinerary.id >= 0 ? 1 : 0
        onClicked: rootView.clearItinerary();
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 30
            bottomMargin: 30
        }
    }
}
