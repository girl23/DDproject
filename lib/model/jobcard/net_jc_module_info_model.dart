class NetJcModuleInfoModel {
  String jcVersion;
  String xmlContent;
  NetJcModuleInfoModel.fromJson(Map<String, dynamic> json) {
    jcVersion = json['jcVersion'];
    xmlContent = json['xmlContent'];
  }
}
