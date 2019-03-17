import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.10


Item {

    Text{
        id: objMessageText
        text: "Current version of Qb is not supported by vLibQB.\n Please update Qb to the latest version."
        anchors.fill: parent
        anchors.centerIn: parent
        color: "grey"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 15
    }

    Button{
        id: objDownloadLink
        text: "Download Latest Qb"
        Material.background: Material.color(Material.Red)
        Material.foreground: "white"
        onClicked: {
            Qt.openUrlExternally("https://github.com/OpenQb/Qb/releases");
        }
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
