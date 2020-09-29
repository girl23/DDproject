import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/add/add_dd_service.dart';
import 'package:lop/service/dd/add/add_dd_service_impl.dart';

class AddDDViewModel extends BaseViewModel with ChangeNotifier{

  //获取列表数据
  AddDDService _service = AddDDServiceImpl();
  Future<bool> addDD(String ddLB, {String number, String planeNo, String keepPerson, String phone, String fax, String reportDate, String reportPlace, int spaceDay, String spaceHour, String spaceCycle, String describe, String keepMeasure, String name, String jno, String faultNum, String inStallNum, String releaseNum, String chapter1, String chapter2, String chapter3, String faultCategory, String influence, String parkingTime, String workHour, String o, String other, String otherDescribe, String m, String aMC, String runLimit, String keepReason, String evidenceType, String chapterNo1, String chapterNo2, String chapterNo3, String chapterNo4, String chapterNo5,
    String mbCode,String workON,String comeFrom,String eng,String startDate,String totalHour, String totalCycle,String endDate,String endHour,String endCycle,String keepFold,String repeatInspection,String applicant,String applyDate }) async{
    NetworkResponse response;
   if(ddLB=='LB'){
          response =  await _service.addDD('LB',number:number,
         planeNo: planeNo,
         keepPerson: keepPerson,
         phone: phone,
         fax: fax,
         reportDate: reportDate,
         reportPlace: reportPlace,
         spaceDay: spaceDay,
         spaceHour: spaceHour,
         spaceCycle: spaceCycle,
         describe: describe,
         keepMeasure: keepMeasure,
         name: name,
         jno: jno,
         faultNum: faultNum,
         releaseNum: releaseNum,
         inStallNum: inStallNum,
         chapter1: chapter1,
         chapter2: chapter2,
         chapter3: chapter3,
         faultCategory: faultCategory,
         influence: influence,
         parkingTime: parkingTime,
         workHour: workHour,
         o:o,
         other: other,
         otherDescribe: otherDescribe,
         m: m,
         aMC: aMC,
         runLimit: runLimit,
         keepReason:keepReason,
         evidenceType: evidenceType,
         chapterNo1: chapterNo1,
         chapterNo2: chapterNo2,
         chapterNo3: chapterNo3,
         chapterNo4: chapterNo4,
         chapterNo5: chapterNo5);

   }else{
     response =  await _service.addDD('DD',
         mbCode: mbCode,
         number:number,
         workON: workON,
         comeFrom: comeFrom,
         planeNo: planeNo,
         eng: eng,
         reportDate: reportDate,
         reportPlace: reportPlace,
         startDate: startDate,
         totalHour: totalHour,
         totalCycle: totalCycle,
         spaceDay: spaceDay,
         spaceHour: spaceHour,
         spaceCycle: spaceCycle,
         endDate: endDate,
         endHour: endHour,
         endCycle: endCycle,
         describe: describe,
         keepMeasure: keepMeasure,
         name: name,
         jno: jno,
         faultNum: faultNum,
         releaseNum: releaseNum,
         inStallNum: inStallNum,
         chapter1: chapter1,
         chapter2: chapter2,
         chapter3: chapter3,
         faultCategory: faultCategory,
         influence: influence,
         parkingTime: parkingTime,
         workHour: workHour,
         o:o,
         other: other,
         otherDescribe: otherDescribe,
         m: m,
         aMC: aMC,
         runLimit: runLimit,
         keepFold: keepFold,
         repeatInspection: repeatInspection,
         keepReason:keepReason,
         evidenceType: evidenceType,
         chapterNo1: chapterNo1,
         chapterNo2: chapterNo2,
         chapterNo3: chapterNo3,
         chapterNo4: chapterNo4,
         chapterNo5: chapterNo5,
         applicant: applicant,
         applyDate: applyDate
     );
   }

    if(response.isSuccess){
      if (response.data.result == 'success') {

        return true;
      }else{
        return false;
      }
    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}