import 'package:lop/database/jc_data_db_model.dart';
import 'package:sqflite/sqflite.dart';

import 'database_util.dart';

///
/// 工卡数据对应的数据库操作类
///
class JcDataDbTools {
  ///
  /// 添加工卡数据信息
  ///
  Future<bool> addJobCardData(JcDataDbModel model) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql =
        "INSERT INTO tb_data_jc(jc_id, type, model_no, data) VALUES(?, ?, ?, ?)";
    int insertId = await db
        .rawInsert(sql, [model.jcId, model.type, model.modelNo, model.data]);
    return insertId > 0;
  }

  ///
  /// 批量添加工卡数据信息
  ///
  Future<bool> addJobCardDataList(List<JcDataDbModel> models) async {
    Database db = await DatabaseUtil.instance.openDb();
    var batch = db.batch();
    models.forEach((model) {
      batch.insert('tb_data_jc', {
        'jc_id': model.jcId,
        'type': model.type,
        'model_no': model.modelNo,
        'data': model.data
      });
    });
    await batch.commit();
    return Future.value(true);
  }

  ///
  /// 根据工卡id删除工卡的所有数据信息
  ///
  Future<bool> deleteJobCardAllData(int jcId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql = "DELETE FROM tb_data_jc WHERE jc_id = '$jcId'";
    int number = await db.rawDelete(sql);
    return number > 0;
  }

  ///
  /// 查询工卡所有数据
  ///
  Future<List<JcDataDbModel>> queryJobCardData(
      int jcId) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql =
        "SELECT * FROM tb_data_jc WHERE jc_id = ? ORDER BY id";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql, [jcId]);
    if (maps == null || maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return JcDataDbModel().parseDataMap(maps[i]);
      });
    }
  }

  ///
  /// 根据"类型"查询工卡数据
  ///
  /// [JcDataDbModel.jcDataDbTypeHeader]，
  /// [JcDataDbModel.jcDataDbTypeModel]，
  /// [JcDataDbModel.jcDataDbTypeFigure]
  ///
  Future<List<JcDataDbModel>> queryJobCardDataByType(
      int jcId, String type) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql =
        "SELECT * FROM tb_data_jc WHERE jc_id = ? AND type = ? ORDER BY id";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql, [jcId, type]);
    if (maps == null || maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return JcDataDbModel().parseDataMap(maps[i]);
      });
    }
  }

  ///
  /// 根据"模块的编号"查询模块数据
  ///
  Future<List<JcDataDbModel>> queryJobCardDataByModelNo(
      int jcId, String noStr) async {
    Database db = await DatabaseUtil.instance.openDb();
    String sql =
        "SELECT * FROM tb_data_jc WHERE jc_id = ? AND type = ? AND model_no IN ($noStr) ORDER BY model_no";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql, [jcId, JcDataDbModel.jcDataDbTypeModel]);
    if (maps == null || maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return JcDataDbModel().parseDataMap(maps[i]);
      });
    }
  }
  ///
  /// 是否有当前工卡的数据
  ///
  Future<bool> hadJobCardData(int jcId) async {
    Database db = await DatabaseUtil.instance.openDb();
    int count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM tb_data_jc WHERE jc_id=$jcId"));
    return count > 0;

  }
}
