import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/delay/dd_delay_service.dart';
import 'package:lop/service/dd/delay/dd_delay_service_impl.dart';
import 'package:lop/viewmodel/dd/ddlist_viewmodel.dart';
import 'package:provider/provider.dart';
class DelayDDViewModel extends BaseViewModel with ChangeNotifier {
  DDListViewModel ddListVM=Provider.of<DDListViewModel>(BaseViewModel.appContext,listen: false);
  DelayDDService _service = DelayDDServiceImpl();
  Future<bool> delay(String ddID, {String number, String planeNo, String keepPerson, String phone, String fax, String reportDate, String reportPlace, int spaceDay, String spaceHour, String spaceCycle, String describe, String keepMeasure, String name, String jno, String faultNum, String inStallNum, String releaseNum, String chapter1, String chapter2, String chapter3, String faultCategory, String influence, String parkingTime, String workHour, String o, String other, String otherDescribe, String m, String aMC, String runLimit, String keepReason, String evidenceType, String chapterNo1, String chapterNo2, String chapterNo3, String chapterNo4, String chapterNo5,
    String mbCode,String workON,String comeFrom,String eng,String startDate,String totalHour, String totalCycle,String endDate,String endHour,String endCycle,String keepFold,String repeatInspection,String applicant,String applyDate,String entryType}) async{
    mbCode='1';
    number='DD-7777';
    workON='指令-777';
    comeFrom='comefrom123';
    planeNo='B-777';
    eng='APU123141';
    reportDate='2020-10-10';
    reportPlace='CFH';
    startDate='2020-10-11';
    totalHour='10';
    totalCycle='10';
    spaceDay=1;
    spaceHour='2';
    spaceCycle='4';
    endDate='2020-10-01';
    endHour='12';
    endCycle='14';
    describe='描述hkhaghkag';
    keepMeasure='措施hakhgkajglajglag';
    name='name';
    jno='jno';
    faultNum='1';
    releaseNum='2';
    inStallNum='3';
    chapter1='11';
    chapter2='22';
    chapter3='33';
    faultCategory='A';
    influence='1';
    parkingTime='2h';
    workHour='2h';
    o='1';
    other='1';
    otherDescribe='其它otherDescribe';
    m='1';
    aMC='1';
    runLimit='1';
    keepFold='1';
    repeatInspection='1';
    keepReason='OISP';
    evidenceType='0';
    chapterNo1='chapterNo1';
    chapterNo2='chapterNo2';
    chapterNo3='chapterNo3';
    chapterNo4='chapterNo4';
    chapterNo5='chapterNo5';
    applicant='zhouzhou';
    applyDate='2020-10-09';
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