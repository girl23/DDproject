import 'package:lop/model/jc_sign_model.dart';

import 'database_util.dart';
import 'temp_dd_model.dart';
import 'package:sqflite/sqflite.dart';
class TempDDTools{
  //增加
  Future<bool> addTempDD(String userId,String key,dynamic value) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "INSERT INTO tempDD(dd_userId,$key) VALUES(?,?)";
    int insertId = await db.rawInsert(sql,[userId,value]);
    return insertId > 0;
  }
  //删除
  Future<bool> deleteTempDD(String userId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "DELETE FROM tempDD WHERE dd_userId = $userId";
    int number = await db.rawDelete(sql);
    return number > 0;
  }
  //查询
  Future<TempDDDbModel> queryTempDD(String userId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "SELECT * FROM tempDD WHERE dd_userId = $userId";
    List<Map<String, dynamic>> data = await db.rawQuery(sql);
    if (data == null || data.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> map = data.first;
      return Future.value(TempDDDbModel().parseDataMap(map));
    }
  }
  //查全部
  Future<List<TempDDDbModel>> queryAllTempDD() async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "SELECT * FROM tempDD";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    if (maps == null || maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return TempDDDbModel().parseDataMap(maps[i]);
      });
    }
  }
  //更改
  Future<bool> updateTempDD(String key, dynamic value,String userId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql;
    sql = "UPDATE tempDD SET $key = ? WHERE dd_userId = ?" ;
    int number = await db.rawUpdate(
        sql, [value,userId]);
    return number > 0;

  }
}