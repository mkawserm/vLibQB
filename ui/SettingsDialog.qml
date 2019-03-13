import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Popup {
    id: objSettingsDialog
    modal: true
    closePolicy: Popup.CloseOnEscape

    property alias gridWidth: objGridWidth.value
    property alias gridHeight: objGridHeight.value
    property alias gridSpacing: objGridSpacing.value
    property alias dataDir: objDataDir.text;

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    Loader{
        id: objFolderChooserLoader
    }

    QbPaths{
        id: objPaths
    }



    Rectangle{
        id: objSettingsDialogTopToolbar
        width: parent.width
        height: QbCoreOne.scale(50)
        color: objMetaTheme.primary
        Material.background: objMetaTheme.primary

        Label{
            height: QbCoreOne.scale(50)
            text: "Settings"
            x: (parent.width - width)/2.0
            anchors.bottom: parent.bottom
            font.pixelSize: 20
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
                objSettingsDialog.close();
            }
            anchors.bottom: parent.bottom
        }
    }

    Column{
        width: parent.width
        height: parent.height - objSettingsDialogTopToolbar.height
        anchors.top: objSettingsDialogTopToolbar.bottom
        anchors.topMargin: 10

        Label{
            text: "Grid Width"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        Row{
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: parent.width
            height: 50
            Slider{
                id: objGridWidth
                from: 10
                value: 100
                to: 1000
                stepSize: 1
                width: parent.width - 50
                height: parent.height
            }

            Label{
                width: 50
                height: 50
                text: objGridWidth.value
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }
        }


        Label{
            text: "Grid Height"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        Row{
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: parent.width
            height: 50
            Slider{
                id: objGridHeight
                from: 10
                value: 100
                to: 1000
                stepSize: 1
                width: parent.width - 50
                height: parent.height
            }

            Label{
                width: 50
                height: 50
                text: objGridHeight.value
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }
        }

        Label{
            text: "Grid Spacing"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        Row{
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: parent.width
            height: 50
            Slider{
                id: objGridSpacing
                from: 10
                value: 10
                to: 500
                stepSize: 1
                width: parent.width - 50
                height: parent.height
            }

            Label{
                width: 50
                height: 50
                text: objGridSpacing.value
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }
        }


        Label{
            text: "Data Location"
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
                id: objDataDir
                width: parent.width - objBrowseButton.width - 20
                height: parent.height
                readOnly: false
                Component.onCompleted: {
                    if(QbCoreOne.isBuiltForRaspberryPi())
                    {
                        if(objDataDir.text === "")
                        {
                            objDataDir.text = objPaths.documents()+"/vLibQB";
                        }
                    }
                    else if(Qt.platform.os === "osx" || Qt.platform.os === "linux" || Qt.platform.os === "windows")
                    {
                        if(objDataDir.text === "")
                        {
                            objDataDir.text = objPaths.documents()+"/vLibQB";
                        }
                    }
                    else
                    {
                        if(objDataDir.text === "")
                        {
                            objDataDir.text = objPaths.documents()+"/vLibQB";
                        }
                    }
                }
            }

            Button{
                id: objBrowseButton
                text: "BROWSE"
                Material.background: objMetaTheme.primary
                onClicked: {
                    objFolderChooserLoader.source = objMainAppUi.absoluteURL("/ui/desktop/DesktopFolderChooser.qml");
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 50
            visible: Qt.platform.os !== "android" && Qt.platform.os !== "ios"

            Text{
                text: "Drag and drop data folder here"
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            DropArea{
                anchors.fill: parent
                onDropped: {
                    if(drop["hasUrls"]){
                        var url =  QbUtil.removeScheme(drop["urls"][0]);
                        //console.log("Dropped something");
                        if(QbUtil.isFolder(url))
                        {
                            drop.accepted = true;
                            objDataDir.text = url;
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
