class JcDataDbModel {

  static final String jcDataDbTypeHeader = 'header';
  static final String jcDataDbTypeModel = 'model';
  static final String jcDataDbTypeFigure = 'figure';


  int id;
  int jcId;
  ///
  ///三个值可选：header\model\figure
  ///对应：[jcDataDbTypeHeader],[jcDataDbTypeModel],[jcDataDbTypeFigure]
  ///
  String type;
  int modelNo = -1;
  String data;
  DateTime createDate;
  DateTime updateDate;

  JcDataDbModel parseDataMap(Map<String, dynamic> dataMap){
    id = dataMap['id'];
    jcId = dataMap['jc_id'];
    type = dataMap['type'];
    modelNo = dataMap['model_no'];
    data = dataMap['data'];
    createDate = DateTime.parse(dataMap['create_date']);
    updateDate = DateTime.parse(dataMap['update_date']);
    return this;
  }


}


