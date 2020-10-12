import 'package:shared_preferences/shared_preferences.dart';
import 'package:lop/database/temp_dd_tools.dart';
import 'package:lop/database/temp_dd_model.dart';
import 'package:lop/database/normal_dd_tools.dart';
import 'package:lop/database/normal_dd_model.dart';
import 'dart:async';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/global.dart';

class DDCacheUtil{
  static  BuildContext appContext =Global.navigatorKey.currentContext;
  static String userId=Provider.of<UserViewModel>(appContext, listen: false).info.userId;
  static Future<TempDDDbModel>  fetchTempDDModel() async {
//    String userId=Provider.of<UserViewModel>(appContext, listen: false).info.userId;
    TempDDDbModel tempDDDbModel = await TempDDTools().queryTempDD(userId);
    return tempDDDbModel;
  }
  static Future<NormalDDDbModel>  fetchNormalDDModel(String fromPage ) async {
//    String userId=Provider.of<UserViewModel>(appContext, listen: false).info.userId;
    NormalDDDbModel normalDDDbModel = await NormalDDTools().queryNormalDD(userId,fromPage);
    return normalDDDbModel;
  }
  static void cacheData(String key,dynamic value){
    SharedPreferences.getInstance().then((pre)async{
      String uiFor= pre.getString("uiFor");

      if(uiFor=='Temp'){

        TempDDDbModel model=await fetchTempDDModel();
        if (model == null) {
          //添加一条数据


          await TempDDTools().addTempDD(userId,key,value);

        }else{
          //更新数据
          bool success= await TempDDTools().updateTempDD(key,value,userId);
        }
      }else{
        //DD
        String fromPage= pre.getString("fromPage");
        NormalDDDbModel model=await fetchNormalDDModel(fromPage);

        if (model == null) {
          //添加一条数据
          await NormalDDTools().addNormalDD(userId,key,value,fromPage);
        }else{
          //更新数据
          bool success= await NormalDDTools().updateNormalDD(key,value,userId,fromPage);
        }
      }
      return pre;
    });


  }
}