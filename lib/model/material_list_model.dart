import 'package:lop/model/material_ameco_model.dart';
import 'package:lop/model/material_ca_model.dart';

class MaterialListModel {
  String result;
  List<MaterialCaModel> data = List<MaterialCaModel>();
  List<MaterialAmecoModel> amecoData = List<MaterialAmecoModel>();
  String isHana;//是否hana新接口

  MaterialListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    isHana = json['ishana'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(MaterialCaModel.fromJson(v));
      });
    }
    if (json['amecodata'] != null) {
      json['amecodata'].forEach((v) {
        amecoData.add(MaterialAmecoModel.fromJson(v));
      });
    }
  }

  MaterialListModel(){
  }

}
