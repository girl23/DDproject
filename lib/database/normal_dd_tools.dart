import 'database_util.dart';
import 'normal_dd_model.dart';
import 'package:sqflite/sqflite.dart';
class NormalDDTools{
  //增加
  Future<bool> addNormalDD(String userId,String key,dynamic value,String fromPage) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "INSERT INTO normalDD(dd_userId,$key,dd_from_page) VALUES(?,?,?)";
    int insertId = await db.rawInsert(sql,[userId,value,fromPage]);
    return insertId > 0;
  }
  //删除
  Future<bool> deleteNormalDD(String userId,String fromPage) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "DELETE FROM normalDD WHERE dd_userId = ? AND dd_from_page=?" ;
    int number = await db.rawDelete(sql,[userId,fromPage]);
    return number > 0;
  }

  //查询
  Future<NormalDDDbModel> queryNormalDD(String userId,String fromPage) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "SELECT * FROM normalDD WHERE dd_userId = ? AND dd_from_page=?";
    List<Map<String, dynamic>> data = await db.rawQuery(sql,[userId,fromPage]);
    if (data == null || data.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> map = data.first;
      return Future.value(NormalDDDbModel().parseDataMap(map));
    }
  }
  //查全部
  Future<List<NormalDDDbModel>> queryAllNormalDD() async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "SELECT * FROM normalDD";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    if (maps == null || maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return NormalDDDbModel().parseDataMap(maps[i]);
      });
    }
  }
  //更改
  Future<bool> updateNormalDD(String key, dynamic value,String userId,String fromPage) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql;
    sql = "UPDATE normalDD SET $key = ? WHERE dd_userId = ? AND dd_from_page=?" ;
    int number = await db.rawUpdate(
        sql, [value,userId,fromPage]);

    return number > 0;

  }
}