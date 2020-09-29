///
import 'package:lop/network/network_response.dart';

abstract class DelayDDService{
  Future<NetworkResponse> delay(String ddID,{String number,String planeNo,String reportDate,String reportPlace
    ,int spaceDay, String spaceHour,String spaceCycle, String describe,String keepMeasure,String name,String jno
    ,String faultNum,String inStallNum,String releaseNum,String chapter1,String chapter2,String chapter3,String faultCategory
    ,String influence,String parkingTime,String workHour,String o,String other ,String otherDescribe,String m,String aMC,String runLimit
    ,String keepReason,String evidenceType,String chapterNo1,String chapterNo2,String chapterNo3,String chapterNo4,String chapterNo5
    ,String mbCode,String workON,String comeFrom,String eng,String startDate,String totalHour, String totalCycle,String endDate,String endHour,String endCycle,String keepFold,String repeatInspection,String applicant,String applyDate,String entryType});

}