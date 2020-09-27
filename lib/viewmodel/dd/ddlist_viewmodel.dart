///dd列表
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/model/dd/dd_list_model.dart';
import 'package:lop/service/dd/ddlist/get_ddlist_service_impl.dart';
import 'package:lop/service/dd/ddlist/get_ddlist_service.dart';

class DDListViewModel extends BaseViewModel with ChangeNotifier{

  //获取列表数据
  GetDDListService _service = GetDDListServiceImpl();
  List <DDListItemModel>_ddList;
  int _total;
  int _page;
  int _pageCount;


  List<DDListItemModel> get ddList => _ddList;

  int get total => _total;

  int get page => _page;

  int get pageCount => _pageCount;

  Future<bool> getList(String ddLB,{bool all,String ddNo, String acReg, String state,String page}) async{
    NetworkResponse response =  await _service.getList(ddLB,page: page);
    if(response.isSuccess){
      DDListModel model=response.data;
      _page=model.page;
      _pageCount=model.pageCount;
      _total=model.total;
      if(this.page==1){
        _ddList=model.data;
      }else{
        _ddList.addAll(model.data);
      }
      notifyListeners();
      return true;

    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }


}
