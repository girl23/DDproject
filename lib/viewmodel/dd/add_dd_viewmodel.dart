import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/add/add_dd_service.dart';
import 'package:lop/service/dd/add/add_dd_service_impl.dart';
import 'package:lop/viewmodel/dd/ddlist_viewmodel.dart';
import 'package:provider/provider.dart';
class AddDDViewModel extends BaseViewModel with ChangeNotifier{
  DDListViewModel ddListVM=new DDListViewModel();
  //获取列表数据
  AddDDService _service = AddDDServiceImpl();
  Future<bool> addDD(String ddLB, {String number, String planeNo, String keepPerson, String phone, String fax, String reportDate, String reportPlace, int spaceDay, String spaceHour, String spaceCycle, String describe, String keepMeasure, String name, String jno, String faultNum, String inStallNum, String releaseNum, String chapter1, String chapter2, String chapter3, String faultCategory, String influence, String parkingTime, String workHour,String planner ,String o, String other, String otherDescribe, String m, String aMC, String runLimit, String keepReason, String evidenceType, String chapterNo1, String chapterNo2, String chapterNo3, String chapterNo4, String chapterNo5,
    String mbCode,String workON,String comeFrom,String eng,String startDate,String totalHour, String totalCycle,String endDate,String endHour,String endCycle,String keepFold,String repeatInspection,String applicant,String applyDate,DDListViewModel listVM }) async{
    NetworkResponse response;
    DDListViewModel _listVM;
    _listVM=Provider.of<DDListViewModel>(BaseViewModel.appContext,listen: false);
    if(ddLB=='LB'){
      number='111';
      planeNo='B-111';
      keepPerson='保留人员周周';
      phone='15187772765';
      fax='028-88888888';
      reportDate='2020-10-10';
      reportPlace='CFH';
      spaceDay=1;
      spaceHour='2';
      spaceCycle='3';
      describe='保留描述';
      keepMeasure='保留措施';
      name='name';
      jno='jno';
      faultNum='1';
      releaseNum='2';
      inStallNum='3';
      chapter1='11';
      chapter2='22';
      chapter3='33';

      faultCategory='CBS-F';
      influence='1';
      parkingTime='2h';
      workHour='2h';
      planner='直管员';
      o='1';
      other='1';
      otherDescribe='其它描述';
      m='1';
      aMC='1';
      runLimit='1';
      keepFold='1';
      repeatInspection='1';
      keepReason='保留原因';
      evidenceType='0';
      chapterNo1='chapterNo1';
      chapterNo2='chapterNo2';
      chapterNo3='chapterNo3';
      chapterNo4='chapterNo4';
      chapterNo5='chapterNo5';
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
         planner: planner,
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
      mbCode='1';
      number='DD-7777';
      workON='指令-777';
      comeFrom='comefrom123';
      planeNo='B-0000';
      eng='APU123141';
      reportDate='2020-10-12';
      reportPlace='CFH';
      startDate='2020-10-13';
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
        if(ddLB=='LB'){
          _listVM.getList('LB',page: '1');
        }else{

          _listVM.getList('DD',page: '1');
        }
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