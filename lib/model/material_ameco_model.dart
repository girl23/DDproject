class MaterialAmecoModel {
  String materialNo; //件号
  String plant; //基地
  String location; //库存地
  String batchNo; //批次

  MaterialAmecoModel.fromJson(Map<String, dynamic> json) {
    materialNo = json['material_no'];
    plant = json['plant'];
    location = json['location'];
    batchNo = json['batch_no'];
  }
}
