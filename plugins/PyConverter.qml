import Qb 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.10

Item {
    id: objRootPyConverter
    property string appId: "";
    property string path;

    property string buildDir;
    property int outputWidth:100;
    property int outputHeight:100;


    QbSettings{
        id: objPySettings
        name: "PyConverter";
        property alias buildDir: objRootPyConverter.buildDir;
        property alias outputWidth: objRootPyConverter.outputWidth;
        property alias outputHeight: objRootPyConverter.outputHeight;
    }

    Component.onCompleted: {
        objPySettings.setAppId(objRootPyConverter.appId);
    }


    Column{
        id: topBar
        spacing: 5
        anchors.top: parent.top
        height: 100
        width: parent.width
        Item{
            height: 26
            width: parent.width
        }

        Item{
            height: 50
            width: parent.width
            Image{
                id: objImageGrid
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                mipmap: true
                smooth: true
                asynchronous: true
                sourceSize.width: width*2
                sourceSize.height: height*2
                source: objRootPyConverter.path
                anchors.centerIn: parent
            }

        }
    }


    ToolBar {
        width: parent.width
        height: 50

        anchors.bottom: parent.bottom
        Material.background: objMetaTheme.primary

        ToolButton{
            id: objBackButton
            text: QbMF3.icon("mf-keyboard_arrow_left")
            font.family: QbMF3.family
            font.pixelSize: height*0.50
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: 30
            Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
            onClicked: {
                objMainAppUi.popPage();
            }
        }

        Button{
            id: objStartButton
            text: "START"
            anchors.right: parent.right
            anchors.rightMargin: 5
            Material.background: objMetaTheme.secondary
            Material.foreground: objMetaTheme.textColor(objMetaTheme.secondary)
            onClicked: {

            }
        }
    }
}
