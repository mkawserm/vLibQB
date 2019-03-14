import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

import Qb 1.0
import Qb.Core 1.0
import Qb.Android 1.0

QbApp{
    id: objMainAppUi
    changeWindowPosition: true;
    minimumHeight: 500
    minimumWidth: 450

    Keys.onReleased: {
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back)
        {
            if(Qt.inputMethod.visible)
            {
                Qt.inputMethod.hide();
                objMainStack.currentItem.forceActiveFocus();
            }
            else
            {
                if(objMainStack.depth === 1)
                {
                    objExitDialog.open();
                }
            }

            event.accepted = true;
        }
    }

    property int gridWidth: 100
    property int gridHeight: 100
    property int gridSpacing: 10
    property string dataDir: ""

    property bool androidFullScreen: false;
    property bool showTopBar: false;
    property bool showLoadingScreen: objMainStack.busy;

    QbSettings{
        id: objSettings
        name: "vLibQB"
        property alias windowWidth: objMainAppUi.windowWidth
        property alias windowHeight: objMainAppUi.windowHeight
        property alias windowX: objMainAppUi.windowX
        property alias windowY: objMainAppUi.windowY

        property alias gridWidth: objMainAppUi.gridWidth
        property alias gridHeight: objMainAppUi.gridHeight
        property alias gridSpacing: objMainAppUi.gridSpacing
        property alias dataDir: objMainAppUi.dataDir
    }

    QbMetaTheme{
        id: objMetaTheme
    }

    /*Desktop MenuBar*/
    Loader{
        id: objMenuBarLoader
        Component.onCompleted: {
            if (!QbCoreOne.isMobilePlatform() && !QbCoreOne.isWebglPlatofrm() && !QbCoreOne.isBuiltForRaspberryPi())
            {
                objMenuBarLoader.source =  objMainAppUi.absoluteURL("/ui/desktop/DesktopMenuBar.qml");
            }
        }
    }
    /*Desktop MenuBar End*/


    /** Android related things **/
    QbAndroidExtras{
        id: objAndroidExtras
    }

    function dpscale(num){
        return QbCoreOne.scale(num);
    }

    function showAndroidStatusBar()
    {
        if(Qt.platform.os !== "android") return;
        objMainAppUi.showTopBar = true;
        objAndroidExtras.showSystemUi();
    }

    function hideAndroidStatusBar()
    {
        if(Qt.platform.os !== "android") return;
        objAndroidExtras.hideSystemUi();
        objMainAppUi.showTopBar = false;
    }

    function enableAndroidFullScreen()
    {
        if(Qt.platform.os !== "android") return;
        objAndroidExtras.enableFullScreen();
        objMainAppUi.showTopBar = false;
    }

    function disableAndroidFullScreen()
    {
        if(Qt.platform.os !== "android") return;
        objAndroidExtras.disableFullScreen();
        objMainAppUi.showTopBar = true;
    }

    function resetAndroidFullScreenState()
    {
        if(objMainAppUi.androidFullScreen)
        {
            objMainAppUi.enableAndroidFullScreen();
        }
        else
        {
            objMainAppUi.disableAndroidFullScreen();
        }
    }
    /**/


    Pane{
        anchors.fill: parent
        Material.theme: Material.Light
        Material.accent: objMetaTheme.accent
        Material.foreground: objMetaTheme.foreground
        Material.background: objMetaTheme.background
        Material.primary: objMetaTheme.primary

        topPadding: 0
        bottomPadding: 0
        rightPadding: 0
        leftPadding: 0

        StackView{
            id: objMainStack
            anchors.fill: parent
            property string appId: objMainAppUi.appId
        }



        /* Loading Screen */
        Rectangle{
            visible: objMainAppUi.showLoadingScreen
            anchors.fill: parent
            color: objMetaTheme.changeTransparency("black",150)
            z: 99999999999
            Text{
                id: objBusyIndicator
                width: 50
                height: 50
                anchors.centerIn: parent
                text: QbFA.icon("fa-spinner")
                color: objMetaTheme.textColor(parent.color)
                font.pixelSize: 25
                font.family: QbFA.family
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                RotationAnimation on rotation {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    direction: RotationAnimation.Clockwise
                    duration: 1000
                }
            }

            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                }
                onDoubleClicked: {
                }
                onPressed: {
                }
            }
        }

        Dialog{
            id: objExitDialog
            width: Math.min(400,parent.width*0.90)
            height: Math.min(300,parent.height*0.90)
            x: (parent.width - width)/2.0
            y: (parent.height - height)/2.0
            modal: true
            title: "Quit vLibQB?"
            standardButtons: Dialog.Ok | Dialog.Cancel
            Label{
                id: objExitDialogLabel
                anchors.fill: parent
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                text: "Do you really want to quit?"
                wrapMode: Label.WordWrap

                Keys.onPressed: {
                    event.accepted = true;
                }

                Keys.onReleased: {
                    event.accepted = true
                    if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back)
                    {
                        objExitDialog.close();
                    }
                }

            }

            onOpened: {
                objExitDialog.forceActiveFocus();
            }

            onClosed: {
                objMainStack.currentItem.forceActiveFocus();
                if(Qt.inputMethod.visible)
                {
                    Qt.inputMethod.hide();
                }
            }

            onAccepted: {
                objMainAppUi.close();
            }

            onRejected: {
                objMainStack.currentItem.forceActiveFocus();
            }
        }

    }


    onWindowReady: {

    }

    onAppStarted: {
        console.log("vLibQB app started.");
        QbUtil.addAppObject(objMainAppUi.appId,"mainStack",objMainStack);
        QbUtil.addAppObject(objMainAppUi.appId,"mainAppUi",objMainAppUi);

        var theme = {};
        theme["primary"] = String(Material.color(Material.BlueGrey));
        theme["accent"] = String(Material.color(Material.Teal));
        theme["secondary"] = String(Material.color(Material.Brown));
        theme["error"] = String(Material.color(Material.Red));
        theme["background"] = "lightgrey";
        theme["foreground"] = "black";
        objMetaTheme.setThemeFromJsonData(JSON.stringify(theme));

        if(objMainAppUi.androidFullScreen)
        {
            enableAndroidFullScreen();
        }
        else
        {
            disableAndroidFullScreen();
        }

        if(QbCoreOne.isCurrentDeviceWindows())
        {

        }
        else if(QbCoreOne.isCurrentDeviceLinux())
        {

        }
        else if(QbCoreOne.isCurrentDeviceMac())
        {

        }
        else
        {

        }

        if( QbApplicationBuildNumber<objMainAppUi.getAppManifest()["minQbBuildNumber"])
        {
            objMainStack.push(objMainAppUi.absoluteURL("/ui/VersionError.qml"))
        }
        else
        {
            objMainStack.push(objMainAppUi.absoluteURL("/ui/ContentUi.qml"),
                              {
                                  "gridWidth": objMainAppUi.gridWidth,
                                  "gridHeight": objMainAppUi.gridHeight,
                                  "gridSpacing": objMainAppUi.gridSpacing,
                                  "dataDir": objMainAppUi.dataDir,
                                  "showSettings": objMainAppUi.dataDir === ""
                              });
        }


    }

    onAppVisible: {
        if(objMainAppUi.androidFullScreen)
        {
            enableAndroidFullScreen();
        }
        else
        {
            disableAndroidFullScreen();
        }
    }

    onAppClosing: {
        QbUtil.cleanAppObject(objMainAppUi.appId);
        console.log("vLibQB app closing.");
    }
}
