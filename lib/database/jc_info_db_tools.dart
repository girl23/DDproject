import 'database_util.dart';
import 'jc_info_db_model.dart';
import 'package:sqflite/sqflite.dart';

///
/// 工卡基本信息的数据库操作类
///
class JcInfoDbTools {
  ///
  /// 添加工卡基本信息
  ///
  Future<bool> addJobCard(int jcId, String version) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "INSERT INTO tb_jc(jc_id, version) VALUES(?, ?)";
    int insertId = await db.rawInsert(sql, [jcId, version]);
    return insertId > 0;
  }

  ///
  /// 根据工卡id删除工卡基本信息
  ///
  Future<bool> deleteJobCard(int jcId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "DELETE FROM tb_jc WHERE jc_id = '$jcId'";
    int number = await db.rawDelete(sql);
    return number > 0;
  }

  ///
  /// 更新工卡的版本信息
  ///
  Future<bool> updateJobCard(int jcId, String version) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql =
        "UPDATE tb_jc SET version = ? , update_date = ? WHERE jc_id = ?";
    int number = await db.rawUpdate(
        sql, [version, DateTime.now().toUtc().toString().toString(), jcId]);
    return number > 0;
  }

  Future<JcInfoDbModel> queryJobCard(int jcId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "SELECT * FROM tb_jc WHERE jc_id = ?";
    List<Map<String, dynamic>> data = await db.rawQuery(sql, [jcId]);
    if (data == null || data.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> map = data.first;
      return Future.value(JcInfoDbModel().parseDataMap(map));
    }
  }

  Future<List<JcInfoDbModel>> queryAllJobCard() async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "SELECT * FROM tb_jc";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    if (maps == null || maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return JcInfoDbModel().parseDataMap(maps[i]);
      });
    }
  }
}
