import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import Qt.labs.platform 1.1

Popup {
    id: objAddDialog
    modal: true
    closePolicy: Popup.NoAutoClose

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0


    Loader{
        id: objFileChooserLoader
    }

    QbPaths{
        id: objPaths
    }

    Rectangle{
        id: objAddDialogTopBar
        width: parent.width
        height: QbCoreOne.scale(50)
        color: objMetaTheme.primary
        Material.background: objMetaTheme.primary

        Label{
            height: QbCoreOne.scale(50)
            text: "Add"
            x: (parent.width - width)/2.0
            anchors.bottom: parent.bottom
            font.pixelSize: 18
            font.bold: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        ToolButton{
            id: objMenu
            height: QbCoreOne.scale(50)
            text: QbMF3.icon("mf-close")
            Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
            font.family: QbMF3.family
            anchors.right: parent.right
            anchors.rightMargin: 5
            onClicked: {
                objAddDialog.close();
            }
            anchors.bottom: parent.bottom
        }
    }

    Column{
        width: parent.width
        height: parent.height - objAddDialogTopBar.height
        anchors.top: objAddDialogTopBar.bottom
        anchors.topMargin: 10

        Label{
            text: "Name"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Author"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Group"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Tags"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Path"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Row{
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: parent.width
            height: 50
            spacing: 5

            TextField{
                id: objFilePath
                width: parent.width - objBrowseButton.width - 20
                height: parent.height
                readOnly: false
            }

            Button{
                id: objBrowseButton
                text: "BROWSE"
                Material.background: objMetaTheme.primary
                onClicked: {
                }
            }
        }

        Label{
            text: "Last modified"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }


        Rectangle{
            width: parent.width
            height: 50
            visible: Qt.platform.os !== "android" && Qt.platform.os !== "ios" && objFilePath.text === ""
            Text{
                text: "Drag and drop svg file here"
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            DropArea{
                anchors.fill: parent
                onDropped: {
                    if(drop["hasUrls"]){
                        var url =  QbUtil.removeScheme(drop["urls"][0]);
                        if(QbUtil.isFile(url))
                        {
                            if(QbUtil.stringIEndsWith(url,".svg")){
                                drop.accepted = true;
                                objFilePath.text = url;
                            }
                            else
                            {
                                drop.accepted = false;
                            }
                        }
                        else
                        {
                            drop.accepted = false;
                        }
                    }
                    else
                    {
                        drop.accepted = false;
                    }
                }
            }
        }


    }

}
