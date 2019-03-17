import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.10

Popup {
    id: objFullView
    modal: true
    closePolicy: Popup.CloseOnEscape
    property string imagePath:""

    background: Rectangle{
        color: "transparent"
    }

    onOpened: {
        objContentContainer.forceActiveFocus();
    }
    Item{
        id: objContentContainer
        anchors.fill: parent
        Keys.onPressed: {
            event.accepted = true;
            //objFullView.close();
        }

        Keys.onReleased: {
            event.accepted = true
            objFullView.close();
        }

        Image{
            width: parent.width*0.90
            height: parent.height*0.90
            anchors.centerIn: parent
            source: objFullView.imagePath
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width*4.0
            sourceSize.height: height*4.0
            mipmap: true
            smooth: true
            asynchronous: true
        }
    }
}
