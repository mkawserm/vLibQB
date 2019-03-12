import QtQuick 2.10
import Qt.labs.platform 1.0

MenuBar {
    id: menuBar

    Menu {
        id: fileMenu
        title: qsTr("File")
        MenuItem {
            text: qsTr("Open")
            onTriggered: {

            }
        }

        MenuItem {
            text: qsTr("Exit")
            onTriggered: {
                Qt.quit();
            }
        }
    }


    Menu {
        id: helpMenu
        title: qsTr("Help")

        MenuItem {
            text: qsTr("Qb")
            onTriggered: {
                Qt.openUrlExternally("https://github.com/OpenQb/Qb/releases");
            }
        }

        MenuItem {
            text: qsTr("GitHub Repo")
            onTriggered: {
                Qt.openUrlExternally("https://github.com/mkawserm/vLibQB");
            }
        }

        MenuItem {
            text: qsTr("About")
            onTriggered: {

            }
        }
    }

}
