import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

import Qb.Core 1.0
import Qb.ORM 1.0

import "../core" as Core

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
        setupDb();
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


    function setupDb(){
        if(objRootContentUi.dataDir !== "")
        {
            objDir.setPath(objRootContentUi.dataDir);
            if(!objDir.exists())
            {
                objDir.mkpath(objRootContentUi.dataDir);
            }

            objVLibQBCore.dbPath = objRootContentUi.dataDir+"/vLibQB.db";
            if(objVLibQBCore.orm.createTables())
            {

            }
            else
            {
                console.log("Failed to create tables")
            }
            objORMQueryModel.search("status",0,"-pk");
        }
    }

    function updateTagList(TagList)
    {
        objLeftSidebar.dataModel.clear();
        objLeftSidebar.dataModel.append({"name":"All"});
        for(var i=0;i<TagList.length;++i)
        {
            objLeftSidebar.dataModel.append({"name": QbUtil.stringToCapitalize(TagList[i])});
        }
    }

    function updateTagListFromModel()
    {
        objLeftSidebar.dataModel.clear();
        objLeftSidebar.dataModel.append({"name":"All"});

        objVLibQBCore.orm.vLibQBKeyValuePairQuery.reset();
        objVLibQBCore.orm.vLibQBKeyValuePairQuery.one("pk","TagList");
        if(objVLibQBCore.orm.vLibQBKeyValuePairQuery.size() === 0)
        {

        }
        else
        {
            try
            {
                var TagList = JSON.parse(objVLibQBCore.orm.vLibQBKeyValuePairQuery.at(0).value);
                for(var i=0;i<TagList.length;++i)
                {
                    objLeftSidebar.dataModel.append({"name": QbUtil.stringToCapitalize(TagList[i])});
                }
            }
            catch(e)
            {

            }
        }

    }

    Component.onCompleted: {
        setupDb();
        updateTagListFromModel();
        objGridView.forceActiveFocus();
    }

    /*Core components*/
    Core.VLibQBCore{
        id: objVLibQBCore
    }

    QbORMQueryModel{
        id: objORMQueryModel
        query: objVLibQBCore.vLibQBModelQuery
        limit: 100
    }


    QbDir{
        id: objDir
    }

    QbFile{
        id: objFileHandler
    }


    LeftSidebar{
        id: objLeftSidebar
        onSelectedTag:{
            console.log(tag);
            if(tag === "All")
            {
                objORMQueryModel.search("status",0,"-pk");
            }
            else
            {
                objORMQueryModel.search("tags",tag,"-pk");
            }
        }
        onClosed:
        {
            objGridView.forceActiveFocus();
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
            updateTagListFromModel();
        }

        onSearchTerm: {
            console.log("New search term found:",searchTag);
            console.log(searchTag);
            if(searchTag === "")
            {
                objORMQueryModel.search("status",0,"-pk");
            }
            else
            {
                objORMQueryModel.search(["name","path","author","tags","group"],searchTag,"-pk");
            }
        }
    }

    Pane{
        id: objContentGridView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: objTopToolBar.bottom
        anchors.bottom: objBottomToolBar.top
        clip: true

        Text{
            anchors.fill: parent
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: "Nothing found"
            font.pixelSize: 20
            color: "grey"
            visible: objORMQueryModel.count === 0
        }

        GridView{
            id: objGridView
            anchors.fill: parent
            model: objORMQueryModel
            visible: objORMQueryModel.count !== 0
            cellWidth: objRootContentUi.gridWidth + objRootContentUi.gridSpacing
            cellHeight: objRootContentUi.gridHeight + objRootContentUi.gridSpacing
            ScrollIndicator.vertical: ScrollIndicator { }
            z: 1
            Keys.onReturnPressed: {
                console.log("Return Pressed")
                enterKeyAction(event);
            }
            Keys.onEnterPressed: {
                console.log("Enter Pressed")
                enterKeyAction(event);
            }



            Keys.onReleased:{
                if(event.key === Qt.Key_Space){
                    event.accepted = true;
                    console.log("Space pressed")
                    var path = objORMQueryModel.query.at(objGridView.currentIndex).path;
                    objFullView.imagePath = Qt.platform.os==="windows"?"file:///"+objRootContentUi.dataDir+"/"+path:
                                                                        "file://"+objRootContentUi.dataDir+"/"+path
                    objFullView.open();
                    objFullView.forceActiveFocus();
                }


            }

            function enterKeyAction(event){
                console.log("Event:")
                console.log(event)
            }

            delegate: Rectangle{
                width: objGridView.cellWidth
                height: objGridView.cellHeight
                color: "transparent"
                border.color: objMetaTheme.primary
                border.width: objGridView.currentIndex === index?1:0
                Image{
                    width: objRootContentUi.gridWidth
                    height: objRootContentUi.gridHeight
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                    asynchronous: true
                    anchors.centerIn: parent
                    sourceSize.width: width*2
                    sourceSize.height: height*2
                    source: Qt.platform.os==="windows"?"file:///"+objRootContentUi.dataDir+"/"+path:"file://"+objRootContentUi.dataDir+"/"+path
                }

                MouseArea{
                    anchors.fill: parent
                    z: 3
                    preventStealing: true
                    onPressed: {
                        objGridView.forceActiveFocus();
                        objGridView.currentIndex = index;
                    }
                    onClicked: {
                        objGridView.forceActiveFocus();
                        objGridView.currentIndex = index;
                    }
                }
            }
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
        onUpdateTagList: {
            objRootContentUi.updateTagList(TagList);
        }
    }

    FullGraphicsView{
        id: objFullView
        width: parent.width
        height: parent.height
        x: 0
        y: 0
        onClosed: {
            objGridView.forceActiveFocus();
        }
    }

    DropArea{
        visible: !objSettingsDialog.visible && !objAddDialog.visible
        anchors.fill: parent
        onDropped: {
            if(drop["hasUrls"])
            {
                var url =  QbUtil.removeScheme(drop["urls"][0]);
                if(QbUtil.isFile(url))
                {
                    if(QbUtil.stringIEndsWith(url,".svg"))
                    {
                        drop.accepted = true;
                        objAddDialog.filePath = url;
                        objAddDialog.open();
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
