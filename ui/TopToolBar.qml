import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

import Qb 1.0
import Qb.Core 1.0

/*Don't use independenlty. It's part of MainUi*/
ToolBar {
    id: objTopToolBar
    width: parent.width
    height: objMainAppUi.showTopBar?QbCoreOne.scale(75):QbCoreOne.scale(50)
    Material.background: objMetaTheme.primary

    signal showLeftSidebar();
    signal showSettings();
    signal searchTerm(string searchTag);

    ToolButton{
        id: objMenu
        height: QbCoreOne.scale(50)
        text: QbMF3.icon("mf-menu")
        Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
        font.family: QbMF3.family
        anchors.left: parent.left
        anchors.leftMargin: 5
        onClicked: {
            objTopToolBar.showLeftSidebar();
        }
        anchors.bottom: parent.bottom
    }


    Rectangle{
        id: objSearchScreen
        height: QbCoreOne.scale(50)*0.70
        width: Math.min(350,(parent.width-100)*0.80)
        color: "white"
        radius: 5
        y: (parent.height-height)/2.0
        x: (parent.width-width)/2.0
        property string placeHolderText: "Search"

        Text{
            id: objSearchIcon
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.height
            height: parent.height
            text: QbCoreOne.icon_font_text_code("mf-search")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: QbCoreOne.icon_font_name("mf-search")
            font.pixelSize: parent.height*0.60
            color: "grey"
        }

        Text{
            id: objPlaceHolderText
            text: objSearchScreen.placeHolderText
            color: "grey"
            anchors.left: objSearchIcon.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 5
            verticalAlignment: TextInput.AlignVCenter
            font.pixelSize: parent.height*0.60
            font.bold: true
            activeFocusOnTab: false
            opacity: 1
        }

        TextInput {
            id: objSearchField
            anchors.left: objSearchIcon.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 5
            verticalAlignment: TextInput.AlignVCenter
            font.pixelSize: parent.height*0.60
            font.bold: true
            activeFocusOnPress: true
            selectionColor: "lightblue"
            selectedTextColor: "black"
            color: "black"
            onFocusChanged: {
                //console.log("TextInput Focus:",focus)
            }
            onTextChanged: {
                if(objSearchField.text.length === 0)
                {
                    objPlaceHolderText.opacity = 1;
                }
                else
                {
                    objPlaceHolderText.opacity = 0;
                }

                objSearchScreen.searchTerm(text);
            }
        }
    }


    ToolButton{
        id: objSettingsMenu
        height: QbCoreOne.scale(50)
        text: QbMF3.icon("mf-settings")
        Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
        font.family: QbMF3.family
        anchors.right: parent.right
        anchors.rightMargin: 5
        onClicked: {
            objTopToolBar.showSettings();
        }
        anchors.bottom: parent.bottom
    }

}
