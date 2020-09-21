import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUtil {
  static const dbName = 'lop.db';
  static const dbVersion = 1;

  static const sqlTableJc = 'CREATE TABLE tb_jc ('
      'id INTEGER PRIMARY KEY, '
      'jc_id INTEGER NOT NULL, '
      'version TEXT NOT NULL, '
      'create_date DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'update_date DATETIME DEFAULT CURRENT_TIMESTAMP);';

  static const sqlTableDataJc = 'CREATE TABLE tb_data_jc ('
      'id INTEGER PRIMARY KEY, '
      'jc_id INTEGER NOT NULL, '
      'type TEXT NOT NULL, '
      'model_no INTEGER, '
      'data TEXT, '
      'create_date DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'update_date DATETIME DEFAULT CURRENT_TIMESTAMP);';

  static const sqlTableTempDD = 'CREATE TABLE tempDD ('
      'id INTEGER PRIMARY KEY, '
      'dd_userId TEXT,'
      'create_date DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'update_date DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'dd_number TEXT,'
      'dd_planeNo TEXT,'
      'dd_reportDate TEXT,'
      'dd_reportPlace TEXT,'
      'dd_keepPerson TEXT,'
      'dd_phoneNumber TEXT,'
      'dd_fax TEXT,'
      'dd_keepMeasure TEXT,'
      'dd_name TEXT,'
      'dd_jno TEXT,'
      'dd_faultNum TEXT,'
      'dd_releaseNum TEXT,'
      'dd_installNum TEXT,'
      'dd_chapter1 TEXT,'
      'dd_chapter2 TEXT,'
      'dd_chapter3 TEXT,'
      'dd_keep_faultCategory TEXT,'
      'dd_influence TEXT,'
      'dd_o Bool,'
      'dd_other Bool,'
      'dd_other_describe TEXT,'
      'dd_oi Bool,'
      'dd_ls Bool,'
      'dd_sg Bool,'
      'dd_sp Bool,'
      'dd_plan_keep_time1 TEXT,'
      'dd_plan_keep_time2 TEXT,'
      'dd_plan_keep_time3 TEXT,'
      'dd_plan_keep_describe TEXT,'
      'dd_need_parking_time TEXT,'
      'dd_need_work_time TEXT,'
      'dd_plan_operator TEXT,'
      'dd_need_m BOOL,'
      'dd_need_run_limit BOOL,'
      'dd_need_amc BOOL,'
      'dd_evidence_type TEXT,'
      'dd_chapter_no1 TEXT,'
      'dd_chapter_no2 TEXT,'
      'dd_chapter_no3 TEXT,'
      'dd_chapter_no4 TEXT,'
      'dd_chapter_no5 TEXT);';

  static const sqlTableNormalDD = 'CREATE TABLE normalDD ('
      'id INTEGER PRIMARY KEY, '
      'dd_userId TEXT,'
      'dd_from_page TEXT,'
      'temp_dd_number TEXT,'
      'dd_first_number TEXT,'
      'dd_delay_times TEXT,'
      'create_date DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'update_date DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'dd_MBCode TEXT,'
      'dd_number1 TEXT,'
      'dd_WorkNo TEXT,'
      'dd_planeNo TEXT,'
      'dd_ENG TEXT,'
      'dd_from TEXT,'
      'dd_firstReportDate TEXT,'
      'dd_firstReportPlace TEXT,'
      'dd_startDate TEXT,'
      'dd_start_time2 TEXT,'
      'dd_start_time3 TEXT,'
      'dd_plan_keep_time1 TEXT,'
      'dd_plan_keep_time2 TEXT,'
      'dd_plan_keep_time3 TEXT,'
      'dd_end_time1 TEXT,'
      'dd_end_time2 TEXT,'
      'dd_end_time3 TEXT,'
      'dd_plan_keep_describe TEXT,'
      'dd_keepMeasure TEXT,'
      'dd_name TEXT,'
      'dd_jno TEXT,'
      'dd_faultNum TEXT,'
      'dd_releaseNum TEXT,'
      'dd_installNum TEXT,'
      'dd_chapter1 TEXT,'
      'dd_chapter2 TEXT,'
      'dd_chapter3 TEXT,'
      'dd_keep_faultCategory TEXT,'
      'dd_influence TEXT,'
      'dd_o Bool,'
      'dd_other Bool,'
      'dd_other_describe TEXT,'
      'dd_oi Bool,'
      'dd_ls Bool,'
      'dd_sg Bool,'
      'dd_sp Bool,'
      'dd_need_parking_time TEXT,'
      'dd_need_work_time TEXT,'
      'dd_need_m BOOL,'
      'dd_need_run_limit BOOL,'
      'dd_need_amc BOOL,'
      'dd_needKeepToFold BOOL,'
      'dd_needRepeatInspection BOOL,'
      'dd_evidence_type TEXT,'
      'dd_chapter_no1 TEXT,'
      'dd_chapter_no2 TEXT,'
      'dd_chapter_no3 TEXT,'
      'dd_chapter_no4 TEXT,'
      'dd_chapter_no5 TEXT,'
      'dd_transfer_date_title TEXT,'
      'dd_delay_date_title TEXT,'
      'dd_applicationDate TEXT);';
  String _dbPath;

  Database _db;

  static DatabaseUtil _instance;
  factory DatabaseUtil() => _getInstance();
  static DatabaseUtil get instance => _getInstance();

  static DatabaseUtil _getInstance() {
    if (_instance == null) {
      _instance = DatabaseUtil._internal();
    }
    return _instance;
  }

  DatabaseUtil._internal();

  void initDatabase() async {
    var databasePath = await getDatabasesPath();
    _dbPath = join(databasePath, dbName);
    bool exists = await Directory(dirname(_dbPath)).exists(); //是否存在数据库

    try {
      if (!exists) {
        print('创建数据库');
        await Directory(dirname(_dbPath)).create(recursive: true); //创建数据库目录
        await openDb(); //创建数据库表
      }
    } catch (e) {
      print(e);
    }
  }

  ///创建数据库表格
  void _createTables(Database db, int version) async {
    print("创建数据库表 ，version = $version");
    if (version == dbVersion) {
      await db.execute(sqlTableJc);
      await db.execute(sqlTableDataJc);
      await db.close();
    }
    await db.execute(sqlTableTempDD);
    await db.execute(sqlTableNormalDD);
  }


  Future<Database> openDb() async {
    if (_db == null || !_db.isOpen) {
      _db = await openDatabase(_dbPath,
          version: dbVersion, onCreate: _createTables);
    }
    return _db;
  }

  Future<void> closeDb() async {
    if (_db != null && _db.isOpen) {
      await _db.close();
    }
  }
}
