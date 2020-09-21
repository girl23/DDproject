import 'package:flutter/foundation.dart';
import 'package:lop/model/material_list_model.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/materialsearch/material_search_service_impl.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';

class MaterialSearchViewModel extends BaseViewModel with ChangeNotifier{

  MaterialSearchSearchImpl _searchSearchImpl = MaterialSearchSearchImpl();

  MaterialListModel _materialListModel = MaterialListModel();

  MaterialListModel get  materialListModel => _materialListModel;

  Future<void> searchMaterial(String matpn) async{
    NetworkResponse response =  await _searchSearchImpl.searchMatList(matpn);
    if(response.isSuccess){
      _materialListModel = response.data;
      notifyListeners();
    }else{
      ToastUtil.makeToast(response.errorEntity.message);
    }
    return null;
  }
  void clear(){
    _materialListModel = MaterialListModel();
    notifyListeners();
  }
}