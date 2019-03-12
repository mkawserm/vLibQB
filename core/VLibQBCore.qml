import Qb.ORM 1.0
import QtQuick 2.0

import "../models"

Item {
    property alias orm: objORM
    property alias dbPath: objORM.dbName

    property alias vLibQBModelQuery: objORM.vLibQBModelQuery
    property alias vLibQBModelDataQuery: objORM.vLibQBModelDataQuery
    property alias vLibQBKeyValuePairQuery: objORM.vLibQBKeyValuePairQuery


    QbORM{
        id: objORM

        onError: {
            console.log(errorText)
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
