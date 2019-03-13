import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Pane {
    id: objRootContentUi

    topPadding: 0
    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0

    property alias gridWidth: objSettingsDialog.gridWidth
    property alias gridHeight: objSettingsDialog.gridHeight
    property alias gridSpacing: objSettingsDialog.gridSpacing
    property alias dataDir: objSettingsDialog.dataDir
    property bool showSettings: false;

    onGridWidthChanged: {
        objMainAppUi.gridWidth = objRootContentUi.gridWidth;
    }
    onGridHeightChanged: {
        objMainAppUi.gridHeight = objRootContentUi.gridHeight;
    }
    onGridSpacingChanged: {
        objMainAppUi.gridSpacing = objRootContentUi.gridSpacing;
    }
    onDataDirChanged: {
        objMainAppUi.dataDir = objRootContentUi.dataDir;
    }

    onShowSettingsChanged: {
        if(showSettings)
        {
            objSettingsDialog.open();
        }
        else
        {
            objSettingsDialog.close();
        }
    }

    LeftSidebar{
        id: objLeftSidebar
        onSelectedTag:{
            console.log(tag);
        }
    }

    TopToolBar{
        id: objTopToolBar
        anchors.top: parent.top

        onShowLeftSidebar:{
            console.log("Showing Left side bar");
            objLeftSidebar.open();
        }

        onShowSettings: {
            console.log("Showing Settings...");
            objRootContentUi.showSettings = true;
        }

        onRefresh: {
            console.log("Refreshing...");
        }

        onSearchTerm: {
            console.log("New search term found:",searchTag);
            console.log(searchTag);
        }
    }

    Pane{
        id: objContentGridView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: objTopToolBar.bottom
        anchors.bottom: objBottomToolBar.top

        GridView{
            anchors.fill: parent

        }
    }


    BottomToolBar{
        id: objBottomToolBar
        anchors.bottom: parent.bottom
    }

    SettingsDialog{
        id: objSettingsDialog
        width: Math.min(500,parent.width*0.90)
        height: Math.min(500,parent.height*0.90)
        x: (parent.width - width)/2.0
        y: (parent.height - height)/2.0
        onClosed: {
            objRootContentUi.showSettings = false;
        }
    }

    AddDialog{
        id: objAddDialog
        width: parent.width*0.90
        height: parent.height*0.90
        x: (parent.width - width)/2.0
        y: (parent.height - height)/2.0
    }

    DropArea{
        anchors.fill: parent
        onDropped: {
            console.log(JSON.stringify(drop));
            drop.accepted = true;
            objAddDialog.open();
        }
    }
}
