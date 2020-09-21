import 'package:shared_preferences/shared_preferences.dart';
import 'package:lop/database/temp_dd_tools.dart';
import 'package:lop/database/temp_dd_model.dart';
import 'package:lop/database/normal_dd_tools.dart';
import 'package:lop/database/normal_dd_model.dart';
import 'dart:async';
class DDCacheUtil{
  static Future<TempDDDbModel>  fetchTempDDModel() async {
    TempDDDbModel tempDDDbModel = await TempDDTools().queryTempDD('2222');
    return tempDDDbModel;
  }
  static Future<NormalDDDbModel>  fetchNormalDDModel(String fromPage ) async {
    NormalDDDbModel normalDDDbModel = await NormalDDTools().queryNormalDD('2222',fromPage);
    return normalDDDbModel;
  }
  static void cacheData(String key,dynamic value){
    SharedPreferences.getInstance().then((pre)async{
      String uiFor= pre.getString("uiFor");

      if(uiFor=='Temp'){

        TempDDDbModel model=await fetchTempDDModel();
        if (model == null) {
          //添加一条数据
          String userId='2222';// Provider.of<UserViewModel>(context, listen: false).info.userId;

          await TempDDTools().addTempDD(userId,key,value);

        }else{
          //更新数据
          bool success= await TempDDTools().updateTempDD(key,value,'2222');
        }
      }else{
        //DD
        String fromPage= pre.getString("fromPage");
        NormalDDDbModel model=await fetchNormalDDModel(fromPage);

        if (model == null) {
          //添加一条数据
          String userId='2222';
          await NormalDDTools().addNormalDD(userId,key,value,fromPage);
        }else{
          //更新数据
          bool success= await NormalDDTools().updateNormalDD(key,value,'2222',fromPage);
        }
      }
      return pre;
    });


  }
}