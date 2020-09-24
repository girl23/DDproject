///增加DD

import 'package:lop/network/network_response.dart';

abstract class AddDDService{

  Future<NetworkResponse> addDD(String ddLB,{String number,String planeNo,String keepPerson,String phone,String fax,String reportDate,String reportPlace
    ,int spaceDay, String spaceHour,String spaceCycle, String describe,String keepMeasure,String name,String jno
    ,String faultNum,String inStallNum,String releaseNum,String chapter1,String chapter2,String chapter3,String faultCategory
    ,String influence,String parkingTime,String workHour,String o,String other ,String otherDescribe,String m,String aMC,String runLimit
    ,String keepReason,String evidenceType,String chapterNo1,String chapterNo2,String chapterNo3,String chapterNo4,String chapterNo5});

}