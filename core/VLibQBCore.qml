import Qb.ORM 1.0
import QtQuick 2.0

import "../models"

Item {
    id: objRootCore
    property alias orm: objORM
    property alias dbPath: objORM.dbName

    property alias vLibQBModelQuery: objORM.vLibQBModelQuery
    property alias vLibQBModelDataQuery: objORM.vLibQBModelDataQuery
    property alias vLibQBKeyValuePairQuery: objORM.vLibQBKeyValuePairQuery

    signal error(string errorText)


    QbORM{
        id: objORM
        autoSetup: false
        onError: {
            objRootCore.error(errorText);
        }

        Component.onCompleted: {

        }

        Component.onDestruction: {
            objORM.closeORM();
        }


        property Component vLibQBModel:Component{
            VLibQBModel{
            }
        }

        property Component vLibQBModelData: Component{
            VLibQBModelData{
            }
        }

        property Component vLibQBKeyValuePair: Component{
            VLibQBKeyValuePair{
            }
        }

        property QbORMQuery vLibQBModelQuery: QbORMQuery{
            model: objORM.vLibQBModel
        }
        property QbORMQuery vLibQBModelDataQuery: QbORMQuery{
            model: objORM.vLibQBModelData
        }
        property QbORMQuery vLibQBKeyValuePairQuery: QbORMQuery{
            model: objORM.vLibQBKeyValuePair
        }
    }


}
