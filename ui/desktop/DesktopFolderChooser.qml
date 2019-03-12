import Qb.Core 1.0
import QtQuick 2.10
import Qt.labs.platform 1.0


FolderDialog {
     id: objFolderDialog
     currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
     folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
     visible: true

     onCurrentFolderChanged: {
         objRootContentUi.dataDir = QbUtil.removeScheme(objFolderDialog.currentFolder);
     }
 }
