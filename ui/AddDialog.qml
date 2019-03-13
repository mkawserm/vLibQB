import Qb 1.0
import Qb.ORM 1.0
import Qb.Core 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Dialog {
    id: objAddDialog
    modal: true
    closePolicy: Popup.NoAutoClose

    property alias errorText: objMessageBox.text

    property int index:-1;
    property alias name: objNameField.text
    property alias author: objAuthorField.text
    property alias group: objGroupField.text
    property alias tags: objTagsField.text
    property alias filePath: objFilePath.text

    property bool isUpdate: false
    property var lastModifiedTimeStamp;
    property alias lastModified: objLastModified.text

    signal updateTagList(var TagList);

    onFilePathChanged: {
        if(filePath !== ""){
            if(!isUpdate){
                lastModifiedTimeStamp = QbORMUtil.getLastModifiedTimestampVariant(filePath);
                lastModified =  QbORMUtil.getDateTimeStringFromUnixTimestamp(lastModifiedTimeStamp);
            }
            else{
                lastModified =  QbORMUtil.getDateTimeStringFromUnixTimestamp(lastModifiedTimeStamp);
            }
        }
    }

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    onClosed: {
        clearFields();
    }


    Loader{
        id: objFileChooserLoader
    }

    QbPaths{
        id: objPaths
    }

    QbFileInfo{
        id: objFileInfoHandler
    }

    QbFile{
        id: objFileHandler
    }

    header: Rectangle{
        id: objAddDialogTopBar
        width: parent.width
        height: QbCoreOne.scale(50)
        color: objMetaTheme.primary
        Material.background: objMetaTheme.primary

        Label{
            height: QbCoreOne.scale(50)
            text: objAddDialog.isUpdate?"Update" :"Add"
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

    footer: Rectangle{
        id: objFooter
        width: parent.width
        height: QbCoreOne.scale(50)
        color: "black"
        Label{
            id: objMessageBox
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: objSaveButton.left
            anchors.rightMargin: 5
            font.pixelSize: 13
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: ""
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Button{
            id: objSaveButton
            height: QbCoreOne.scale(50)
            text: objAddDialog.isUpdate?"UPDATE":"SAVE"
            Material.background: objMetaTheme.primary
            Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 5
            onClicked: {
                /*Save here*/
                objAddDialog.addOrUpdate();
            }
        }
    }


    Column{
        anchors.fill: parent
        clip: true

        Label{
            text: "Name"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        TextField{
            id: objNameField
            width: parent.width - 10
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Author"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        TextField{
            id: objAuthorField
            width: parent.width - 10
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Group"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        TextField{
            id: objGroupField
            width: parent.width - 10
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Label{
            text: "Tags"
            anchors.left: parent.left
            anchors.leftMargin: 5
        }
        TextField{
            id: objTagsField
            width: parent.width - 10
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Row{
            width: parent.width
            height: 50
            spacing: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            Label{
                text: "Last modified: "
            }
            Label{
                id: objLastModified
                height: 50
            }
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
                visible: objAddDialog.visible
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


    /*Add or Update Logic*/
    function clearFields(){
        objAddDialog.name = "";
        objAddDialog.group = "";
        objAddDialog.author = "";
        objAddDialog.tags = "";
        objAddDialog.filePath = "";
        objAddDialog.lastModifiedTimeStamp = "";
        objAddDialog.lastModified = "";
        objAddDialog.errorText = "";

        objAddDialog.index = -1;

        /*flags*/
        objFilePath.readOnly = false;
        objBrowseButton.enabled = true;
    }

    function addOrUpdate(){
        if(objAddDialog.name === "")
        {
            objAddDialog.errorText = "Name can not be empty";
        }
        else if(objAddDialog.author === "")
        {
            objAddDialog.errorText = "Author can not be empty";
        }
        else if(objAddDialog.group === "")
        {
            objAddDialog.errorText = "Group can not be empty";
        }
        else if(objAddDialog.tags === "")
        {
            objAddDialog.errorText = "Tags can not be empty";
        }
        else if(objAddDialog.filePath === ""){
            objAddDialog.errorText = "Must add a file path";
        }
        else{
            var TagList = [];
            var dtags = [];
            var d = {};

            if(objAddDialog.isUpdate)
            {
                objFilePath.readOnly = true;
                objBrowseButton.enabled = false;
                if(index !=-1)
                {

                    dtags = [];
                    if(QbUtil.stringContains(objAddDialog.tags,","))
                    {
                        dtags = QbUtil.stringTokenList(objAddDialog.tags,",");
                    }
                    else if(QbUtil.stringContains(objAddDialog.tags,";"))
                    {
                        dtags = QbUtil.stringTokenList(objAddDialog.tags,";");
                    }
                    else{
                        dtags = QbUtil.stringTokenList(objAddDialog.tags," ");
                    }

                    for(var i=0;i<dtags.length;++i)
                    {
                        var ntag = QbUtil.stringToLower(QbUtil.stringTrimmed(dtags[i]));
                        if(TagList.indexOf(ntag) === -1)
                        {
                            TagList.push(ntag);
                        }
                    }

                    d = {};
                    d["name"] = objAddDialog.name;
                    d["author"] = objAddDialog.author;
                    d["group"] = objAddDialog.group;
                    d["tags"] = dtags;
                    //d["lastModified"] = objAddDialog.lastModifiedTimeStamp;
                    //d["path"] = objAddDialog.filePath;
                    //d["status"] = 0;
                    //d["hasData"] = 0;
                    //d["hash"] = "";

                    if(objORMQueryModel.update(objAddDialog.index,d))
                    {
                        //Tag update
                        var TagListMap = {};
                        objVLibQBCore.orm.vLibQBKeyValuePairQuery.one("pk","TagList");
                        if(objVLibQBCore.orm.vLibQBKeyValuePairQuery.size() === 0)
                        {
                            TagListMap["pk"] = "TagList";
                            TagListMap["value"] = JSON.stringify(TagList);
                            objVLibQBCore.orm.vLibQBKeyValuePairQuery.add(TagListMap)
                            objVLibQBCore.orm.vLibQBKeyValuePairQuery.reset();
                        }
                        else
                        {
                            try
                            {
                                var oldTagList = JSON.parse(objVLibQBCore.orm.vLibQBKeyValuePairQuery.at(0).value);
                                for(var i=0;i<oldTagList.length;++i)
                                {
                                    var ntag = oldTagList[i];
                                    if(TagList.indexOf(ntag) === -1)
                                    {
                                        TagList.push(ntag);
                                    }
                                }
                                TagListMap["pk"] = "TagList";
                                TagListMap["value"] = JSON.stringify(TagList);
                                objVLibQBCore.orm.vLibQBKeyValuePairQuery.update(TagListMap)
                                objVLibQBCore.orm.vLibQBKeyValuePairQuery.reset();
                            }
                            catch(e)
                            {
                            }
                        }

                        objAddDialog.updateTagList(TagList);
                        objAddDialog.clearFields();
                        objAddDialog.close();
                    }
                    else
                    {
                        objAddDialog.errorText = "Failed to update";
                    }

                }
                else
                {
                    objAddDialog.errorText = "Please give an index"
                }
            }
            else
            {
                objFileInfoHandler.setFile(objAddDialog.filePath);
                var fileName = objFileInfoHandler.fileName();
                var cFilePath = objRootContentUi.dataDir+"/"+fileName;

                objFileHandler.setFileName(cFilePath);
                if(objFileHandler.exists()){
                    objAddDialog.errorText = "File already exists";
                    return;
                }
                else{
                    if(!objFileHandler.copy(objAddDialog.filePath,cFilePath))
                    {
                        objAddDialog.errorText = "Failed to copy the file to the data dir";
                        return;
                    }
                }

                dtags = [];
                if(QbUtil.stringContains(objAddDialog.tags,","))
                {
                    dtags = QbUtil.stringTokenList(objAddDialog.tags,",");
                }
                else if(QbUtil.stringContains(objAddDialog.tags,";"))
                {
                    dtags = QbUtil.stringTokenList(objAddDialog.tags,";");
                }
                else{
                    dtags = QbUtil.stringTokenList(objAddDialog.tags," ");
                }

                for(var i=0;i<dtags.length;++i)
                {
                    var ntag = QbUtil.stringToLower(QbUtil.stringTrimmed(dtags[i]));
                    if(TagList.indexOf(ntag) === -1)
                    {
                        TagList.push(ntag);
                    }
                }

                d = {};
                d["name"] = objAddDialog.name;
                d["author"] = objAddDialog.author;
                d["group"] = objAddDialog.group;
                d["tags"] = dtags;
                d["lastModified"] = objAddDialog.lastModifiedTimeStamp;
                d["path"] = fileName;
                d["status"] = 0;
                d["hasData"] = 0;
                d["hash"] = "";

                if(objORMQueryModel.prepend(d))
                {
                    //TagUpdate
                    var TagListMap = {};
                    objVLibQBCore.orm.vLibQBKeyValuePairQuery.one("pk","TagList");
                    if(objVLibQBCore.orm.vLibQBKeyValuePairQuery.size() === 0)
                    {
                        TagListMap["pk"] = "TagList";
                        TagListMap["value"] = JSON.stringify(TagList);

                        objVLibQBCore.orm.vLibQBKeyValuePairQuery.add(TagListMap)
                        objVLibQBCore.orm.vLibQBKeyValuePairQuery.reset();
                    }
                    else
                    {
                        try
                        {
                            var oldTagList = JSON.parse(objVLibQBCore.orm.vLibQBKeyValuePairQuery.at(0).value);
                            for(var i=0;i<oldTagList.length;++i)
                            {
                                var ntag = oldTagList[i];
                                if(TagList.indexOf(ntag) === -1)
                                {
                                    TagList.push(ntag);
                                }
                            }
                            TagListMap["pk"] = "TagList";
                            TagListMap["value"] = JSON.stringify(TagList);

                            objVLibQBCore.orm.vLibQBKeyValuePairQuery.update(TagListMap)
                            objVLibQBCore.orm.vLibQBKeyValuePairQuery.reset();
                        }
                        catch(e)
                        {
                        }
                    }

                    objAddDialog.updateTagList(TagList);
                    objAddDialog.clearFields();
                    objAddDialog.close();
                }
                else
                {
                    objAddDialog.errorText = "Failed to add";
                }

            }
        }

    }
}
