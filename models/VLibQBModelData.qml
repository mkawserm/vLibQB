import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "vLibQBModelData"
    pk: QbORMField.unsignedBigIntegerNumber(0,true,true); /* Note PK */

    property var bdata: QbORMField.binary("","bdata",false,false,false)
    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
