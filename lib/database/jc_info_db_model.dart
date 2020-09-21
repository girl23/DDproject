
class JcInfoDbModel{

  int id;
  int jcId;
  String version;
  DateTime createDate;
  DateTime updateDate;

  JcInfoDbModel parseDataMap(Map<String, dynamic> dataMap){
    id = dataMap['id'];
    jcId = dataMap['jc_id'];
    version = dataMap['version'];
    createDate = DateTime.parse(dataMap['create_date']);
    updateDate = DateTime.parse(dataMap['update_date']);
    return this;
  }

}