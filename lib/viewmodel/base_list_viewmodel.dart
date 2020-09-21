import 'package:lop/provide/view_state_model.dart';
///
class BaseListViewModel extends ViewStateModel{
  initData({isLoading = false}){
    if(isLoading){
      setLoading();
    }
    getData();
  }
  getData(){
    setIdle();
    setEmpty();
  }
}