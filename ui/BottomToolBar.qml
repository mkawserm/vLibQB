import Qb 1.0

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

/*Don't use independenlty. It's part of MainUi*/
Item {
    width: parent.width
    height: 50

    Row{
        width: childrenRect.width
        height: parent.height
        anchors.centerIn: parent
        spacing: 10
        Button{
            id: objPrevButton
            text: QbMF3.icon("mf-keyboard_arrow_left")
            font.family: QbMF3.family
            font.pixelSize: height*0.50
            Material.background: objMetaTheme.primary
            Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
            //Material.theme: Material.Dark
            enabled: objRootContentUi.currentPage>1
            onClicked: {
                objRootContentUi.currentPage--;
                objORMQueryModel.page(objRootContentUi.currentPage);
            }
        }
        Button{
            id: objNextButton
            text: QbMF3.icon("mf-keyboard_arrow_right")
            font.family: QbMF3.family
            font.pixelSize: height*0.50
            Material.background: objMetaTheme.primary
            Material.foreground: objMetaTheme.textColor(objMetaTheme.primary)
            //Material.theme: Material.Dark
            enabled: objRootContentUi.currentPage<objRootContentUi.totalPages
            onClicked: {
                objRootContentUi.currentPage++;
                objORMQueryModel.page(objRootContentUi.currentPage);
            }
        }
    }
}
