
import 'dart:convert' as convert;

import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/model/dd/dd_public_model.dart';
import '../../base_service.dart';
import 'package:lop/service/dd/transfer/transfer_dd_service.dart';

class TransferDDServiceImpl extends BaseService implements TransferDDService{
  @override
  Future<NetworkResponse> transferDD(String ddID, {String number, String planeNo, String reportDate, String reportPlace, int spaceDay, String spaceHour, String spaceCycle, String describe, String keepMeasure, String name, String jno, String faultNum, String inStallNum, String releaseNum, String chapter1, String chapter2, String chapter3, String faultCategory, String influence, String parkingTime, String workHour, String o, String other, String otherDescribe, String m, String aMC, String runLimit, String keepReason, String evidenceType, String chapterNo1, String chapterNo2, String chapterNo3, String chapterNo4, String chapterNo5
    ,String mbCode,String workON,String comeFrom,String eng,String startDate,String totalHour, String totalCycle,String endDate,String endHour,String endCycle,String keepFold,String repeatInspection,String applicant,String applyDate,String entryType}) async{
    // TODO: implement AddDD
    Map<String,dynamic> params = new Map();
    params.addAll({Element.FORM_TYPE:'LB'});
    params.addAll({Element.DD_ID:ddID});
    params.addAll({Element.NUMBER:number});
    params.addAll({Element.PLANE_NO:planeNo});
    params.addAll({Element.REPORT_DATE:reportDate});
    params.addAll({Element.REPORT_PLACE:reportPlace});
    params.addAll({Element.SPACE_DAY:spaceDay});
    params.addAll({Element.SPACE_HOUR:spaceHour});
    params.addAll({Element.SPACE_CYC:spaceCycle});
    params.addAll({Element.DESCRIBE:describe});
    params.addAll({Element.KEEP_MEASURE:keepMeasure});
    params.addAll({Element.NAME:name});
    params.addAll({Element.JNO:jno});
    params.addAll({Element.FAULT_NUM:faultNum});
    params.addAll({Element.RELEASE_NUM:releaseNum});
    params.addAll({Element.INSTALL_NUM:inStallNum});
    params.addAll({Element.CHAPTER1:chapter1});
    params.addAll({Element.CHAPTER2:chapter2});
    params.addAll({Element.CHAPTER3:chapter3});
    params.addAll({Element.FAULT_CATEGORY:faultCategory});
    params.addAll({Element.INFLUENCE:influence});
    params.addAll({Element.PARK_TIME:parkingTime});
    params.addAll({Element.WORK_HOUR:workHour});
    params.addAll({Element.O:o});
    params.addAll({Element.OTHER:other});
    params.addAll({Element.OTHER_DESCRIBE:otherDescribe});
    params.addAll({Element.M:m});
    params.addAll({Element.RUN_LIMIT:runLimit});
    params.addAll({Element.AMC:aMC});
    params.addAll({Element.KEEP_REASON:keepReason});
    params.addAll({Element.EVIDENCE_TYPE:evidenceType});
    params.addAll({Element.CHAPTER_NO1:chapterNo1});
    params.addAll({Element.CHAPTER_NO2:chapterNo2});
    params.addAll({Element.CHAPTER_NO3:chapterNo3});
    params.addAll({Element.CHAPTER_NO4:chapterNo4});
    params.addAll({Element.CHAPTER_NO5:chapterNo5});

    params.addAll({Element.MB_CODE:mbCode});
    params.addAll({Element.WORK_ON:workON});
    params.addAll({Element.COME_FROM:comeFrom});
    params.addAll({Element.ENG:eng});
    params.addAll({Element.START_DATE:startDate});
    params.addAll({Element.TOTAL_HOUR:totalHour});
    params.addAll({Element.TOTAL_CYCLE:totalCycle});
    params.addAll({Element.END_DATE:endDate});
    params.addAll({Element.END_HOUR:endHour});
    params.addAll({Element.END_CYCLE:endCycle});
    params.addAll({Element.KEEP_FOLD:keepFold});
    params.addAll({Element.REPEAT_INSPECTION:repeatInspection});
//    params.addAll({Element.APPLICANT:applicant});
    params.addAll({Element.APPLY_DATE:applyDate});
    params.addAll({Element.entryType:entryType});

    String json=convert.jsonEncode(params);
//    print('****$json');
//    Map<String,dynamic> realParams = new Map();

//    realParams.addAll({Element.JSON_DATA:json});
    NetworkResponse networkResponse = await networkRequest.request<DDPublicModel>(NetworkRequest.networkMethod_POST, NetServicePath. ddTransferRequest,data: json);
    return networkResponse;
  }

}