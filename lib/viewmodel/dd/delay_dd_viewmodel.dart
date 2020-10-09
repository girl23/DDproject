import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/delay/dd_delay_service.dart';
import 'package:lop/service/dd/delay/dd_delay_service_impl.dart';
import 'package:lop/viewmodel/dd/ddlist_viewmodel.dart';
class DelayDDViewModel extends BaseViewModel with ChangeNotifier {
  DDListViewModel ddListVM=new DDListViewModel();
  DelayDDService _service = DelayDDServiceImpl();
  Future<bool> delay(String ddID, {String number, String planeNo, String keepPerson, String phone, String fax, String reportDate, String reportPlace, int spaceDay, String spaceHour, String spaceCycle, String describe, String keepMeasure, String name, String jno, String faultNum, String inStallNum, String releaseNum, String chapter1, String chapter2, String chapter3, String faultCategory, String influence, String parkingTime, String workHour, String o, String other, String otherDescribe, String m, String aMC, String runLimit, String keepReason, String evidenceType, String chapterNo1, String chapterNo2, String chapterNo3, String chapterNo4, String chapterNo5,
    String mbCode,String workON,String comeFrom,String eng,String startDate,String totalHour, String totalCycle,String endDate,String endHour,String endCycle,String keepFold,String repeatInspection,String applicant,String applyDate,String entryType}) async{
    mbCode='hhh';
    number='123';
    workON='3434';
    planeNo='B123';
    eng='123141';
    reportDate='2012-02-02';
    reportPlace='CFH';
    startDate='2012-12-12';
    totalHour='12';
    totalCycle='12';
    spaceDay=1;
    spaceHour='2';
    spaceCycle='4';
    endDate='2012-12-12';
    endHour='2';
    endCycle='3';
    describe='hkhaghkag';
    keepMeasure='hakhgkajglajglag';
    name='name';
    jno='jno';
    faultNum='1';
    releaseNum='3';
    inStallNum='4';
    chapter1='11';
    chapter2='22';
    chapter3='33';
    chapterNo1='1hhga';
    chapterNo2='1hhga';
    chapterNo3='1hhga';
    chapterNo4='1hhga';
    chapterNo5='1hhga';
    faultCategory='OI';
    influence='1';
    parkingTime='2h';
    workHour='2';
    o='1';
    other='1';
    otherDescribe='otherDescribe,';
    m='1';
    aMC='1';
    runLimit='1';
    keepFold='1';
    repeatInspection='1';
    keepReason='1gagdag';
    evidenceType='0';
    chapterNo1='1gagdag';
    chapterNo2='1gagdag';
    chapterNo3='1gagdag';
    chapterNo4='1gagdag';
    chapterNo5='1gagdag';

    applyDate='2012-03-03';
    entryType='APP';


    NetworkResponse response =  await _service.delay(ddID,
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
      applyDate: applyDate,
      entryType: entryType,
    );

    if(response.isSuccess){
      if (response.data.result == 'success') {
        ddListVM.getList('DD',page:'1');
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