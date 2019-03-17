import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.10

Drawer {
    id: objLeftSideBar
    width: Qt.platform.os === "android" || Qt.platform.os === "ios"?0.60 * parent.width:250
    height: parent.height
    Material.background: "white"

    signal selectedTag(string tag);

    property alias dataModel: objDataModel

    ListModel{
        id: objDataModel
        ListElement{
            name: "All"
        }
    }


    ListView{
        id: objListView
        anchors.fill: parent
        model: objDataModel
        header: Item{
            width: objListView.width
            height: 50
        }
        headerPositioning: ListView.OverlayHeader

        delegate: Item{
            width: objListView.width
            height: 50
            Label {
                id: objTagLabel
                anchors.centerIn: parent
                anchors.fill: parent
                anchors.leftMargin: 10
                color: "black"
                text: name
                verticalAlignment: Label.AlignVCenter
                elide: Label.ElideRight
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        objTagLabel.color = objMetaTheme.primary;
                    }
                    onExited: {
                        objTagLabel.color = "black";
                    }

                    onClicked: {
                        objLeftSideBar.selectedTag(name);
                        objLeftSideBar.close();
                    }
                    onPressed: {
                        objLeftSideBar.selectedTag(name);
                        objLeftSideBar.close();
                    }
                }
            }
        }
    }
}
