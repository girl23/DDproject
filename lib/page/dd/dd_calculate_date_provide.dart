import 'package:flutter/material.dart';
import 'package:lop/utils/date_util.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
class DDCalculateProvide with ChangeNotifier{
  //已转未审批，临保界面显示处理结果，并禁用按钮
  //用于记录DD
  String _firstReportTime='';
  String _startTime='';//起始日期
  String _space='';//间隔
  String _endTime='';//到期日期
  String _totalHour='';//总飞行小时
  String _spaceHour='';//间隔小时
  String _endHour='';//到期小时
  String _totalCycle='';//总飞行循环
  String _spaceCycle='';//间隔循环
  String _endCycle='';
  bool _canCalculate;

  //用于记录临保
  String _day='';
  String _hour='';
  String _cycle='';

  //=================================================日期动态计算=========================================
  String addOneDay(String day,int space){
    DateTime firstDate;
    DateTime startDate;
    firstDate=DateTime.parse(day);
    startDate=firstDate.add(new Duration(days: space));
    return DateUtil.formateYMD(startDate);
  }
  //减少天数
  String  subTractOneDay(String day,int space){
    DateTime firstDate;
    DateTime startDate;
    startDate=DateTime.parse(day);
    firstDate=startDate.subtract(new Duration(days: space));
    return DateUtil.formateYMD(firstDate);
  }
  String fetchEnd(String startStr,String spaceStr){
    DateTime startDate;
    int space;
    DateTime end;
    startDate=DateTime.parse(startStr);
    space=int.parse(spaceStr);
    end=startDate.add(new Duration(days: space));
    _startTime=startStr;
    _space=spaceStr;
    return DateUtil.formateYMD(end);
  }
  String fetchSpace(String startStr,String endStr){
    DateTime startDate;
    DateTime end;
    startDate=DateTime.parse(startStr);
    end=DateTime.parse(endStr);
    Duration duration=end.difference(startDate);
    _startTime=startStr;
    _endTime=endStr;
    String tempStr= duration.toString();
     String temp2= tempStr.split(':').first;
    int tempHour=int.parse(temp2);
    double tempDay=tempHour/24;
    return tempDay.toString().split('.').first;

  }
  String fetchStart(String endStr,String spaceStr){
    DateTime startDate;
    int space;
    DateTime end;
    space=int.parse(spaceStr);
    end=DateTime.parse(endStr);
    startDate=end.subtract(new Duration(days: space));
    _space=spaceStr;
    _endTime=endStr;
    return DateUtil.formateYMD(startDate);
  }
 void calculateStartAndFirstDate({bool addOneDay}){

    if(addOneDay){
      //有首次报告日期，计算起始日期
     _startTime=this.addOneDay(_firstReportTime, 1);
     notifyListeners();
     DDCacheUtil.cacheData('dd_startDate', _startTime);

    }else{
      //有起始日期，计算首次报告日期
      _firstReportTime=this.subTractOneDay(_startTime, 1);
      notifyListeners();
      DDCacheUtil.cacheData('dd_firstReportDate', _firstReportTime);
    }
    //查看起始日期，计划保留天数，到期是否有数据，有同时更改相应数据
   if(_startTime.length>0&&_space.length>0&&_endTime.length>0){
     this.calculateDate(trigger: 'start');
   }
  }
  void calculateDate({String trigger}){
    DateTime startDate;
    int space;
    DateTime end;
    RegExp exp = RegExp(r"^([0-9-]){0,}$");
    bool matched1 = exp.hasMatch(_startTime);
    bool matched2 = exp.hasMatch(_space);
    bool matched3 = exp.hasMatch(_endTime);
    if(!(matched1==true&&matched2==true&&matched3==true)){
      return;
    }
    //起始+间隔
    if(_startTime.length>0&&_space.length>0&&(_endTime==null||_endTime.length<=0)){
      print('起始+间隔');
      _endTime=this.fetchEnd(_startTime,_space);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time1', _endTime);
      return;
    }
    //起始+到期
    if(_startTime.length>0&&(_space==null||_space.length<=0)&&_endTime.length>0){
      print('起始+到期');
      _space=this.fetchSpace(_startTime,_endTime);
      notifyListeners();
      DDCacheUtil.cacheData('dd_plan_keep_time1', _space);
      return;
    }
    //间隔+到期
    if((_startTime==null||_startTime.length<=0)&&_space.length>0&&_endTime.length>0){
      print('间隔+到期');
      _startTime=this.fetchStart(_endTime, _space);
      calculateStartAndFirstDate();
      DDCacheUtil.cacheData('dd_startDate', _startTime);
      return;
    }
    //更改
    if((_startTime.length>0&&_space.length>0&&_endTime.length>0)&&trigger=='start'){
      print('==start');
      //起始更改，间隔不变，自动计算到期
      _endTime=this.fetchEnd(_startTime,_space);
      calculateStartAndFirstDate();
      DDCacheUtil.cacheData('dd_end_time1', _endTime);
      return;
    }
    if((_startTime.length>0&&_space.length>0&&_endTime.length>0)&&trigger=='space'){
      print('==space');
      //间隔更改，起始不变，自动计算到期
      _endTime=this.fetchEnd(_startTime,_space);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time1', _endTime);

      return;
    }
    if((_startTime.length>0&&_space.length>0&&_endTime.length>0)&&trigger=='end'){
      print('==end');
      //到期更改，起始不变，自动计算间隔
      _space=this.fetchSpace(_startTime, _endTime);
      notifyListeners();
      DDCacheUtil.cacheData('dd_plan_keep_time1',_space);

      return;
    }
  }
  //=================================================小时动态计算=========================================
  String fetchEndHour(String startStr,String spaceStr){
    int start=int.parse(startStr);
    int space=int.parse(spaceStr);
    int end=start+space;
    return end.toString();
  }
  String fetchSpaceHour(String startStr,String endStr){
    int start=int.parse(startStr);
    int end=int.parse(endStr);
    int space=end-start;
    return space.toString();

  }
  String fetchStartHour(String endStr,String spaceStr){
    int space=int.parse(spaceStr);
    int end=int.parse(endStr);
    int start=end-space;
    return start.toString();
  }
  void calculateHour({String trigger}){
    RegExp exp = RegExp(r"^([0-9-]){0,}$");
    bool matched1 = exp.hasMatch(_totalHour);
    bool matched2 = exp.hasMatch(_spaceHour);
    bool matched3 = exp.hasMatch(_endHour);
    if(!(matched1==true&&matched2==true&&matched3==true)){
     return;
    }

    //起始+间隔
    if(_totalHour.length>0&&_spaceHour.length>0&&(_endHour==null||_endHour.length<=0)){
      print('起始+间隔');
      _endHour=this.fetchEndHour(_totalHour,_spaceHour);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time2', _endHour);
      return;
    }
    //起始+到期
    if(_totalHour.length>0&&(_spaceHour==null||_spaceHour.length<=0)&&_endHour.length>0){
      print('起始+到期');
      _spaceHour=this.fetchSpaceHour(_totalHour,_endHour);
      notifyListeners();
      DDCacheUtil.cacheData('dd_plan_keep_time2', _spaceHour);
      return;
    }
    //间隔+到期
    if((_totalHour==null||_totalHour.length<=0)&&_spaceHour.length>0&&_endHour.length>0){
      print('间隔+到期');
      _totalHour=this.fetchStartHour(_endHour, _spaceHour);
      notifyListeners();
      DDCacheUtil.cacheData('dd_start_time2', _totalHour);
      return;
    }
    //更改
    if((_totalHour.length>0&&_spaceHour.length>0&&_endHour.length>0)&&trigger=='start'){
      print('==start');
      //起始更改，间隔不变，自动计算到期
      _endHour=this.fetchEndHour(_totalHour,_spaceHour);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time2', _endHour);
      return;
    }
    if((_totalHour.length>0&&_spaceHour.length>0&&_endHour.length>0)&&trigger=='space'){
      print('==space');
      //间隔更改，起始不变，自动计算到期
      _endHour=this.fetchEndHour(_totalHour,_spaceHour);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time2', _endHour);
      return;
    }
    if((_totalHour.length>0&&_spaceHour.length>0&&_endHour.length>0)&&trigger=='end'){
      print('==end');
      //到期更改，起始不变，自动计算间隔
      _spaceHour=this.fetchSpaceHour(_totalHour, _endHour);
      notifyListeners();
      DDCacheUtil.cacheData('dd_plan_keep_time2', _spaceHour);
      return;
    }
  }
  //=================================================循环动态计算==========================================
  String fetchEndCycle(String startStr,String spaceStr){
    int start=int.parse(startStr);
    int space=int.parse(spaceStr);
    int end=start+space;
    return end.toString();
  }
  String fetchSpaceCycle(String startStr,String endStr){
    int start=int.parse(startStr);
    int end=int.parse(endStr);
    int space=end-start;
    return space.toString();

  }
  String fetchStartCycle(String endStr,String spaceStr){
    int space=int.parse(spaceStr);
    int end=int.parse(endStr);
    int start=end-space;
    return start.toString();
  }
  void calculateCycle({String trigger}){

    RegExp exp = RegExp(  r"^([0-9-]){0,}$");

    bool matched1 = exp.hasMatch(_totalCycle);
    bool matched2 = exp.hasMatch(_spaceCycle);
    bool matched3 = exp.hasMatch(_endCycle);

    if(!(matched1==true&&matched2==true&&matched3==true)){
      return;
    }
    //起始+间隔
    if(_totalCycle.length>0&&_spaceCycle.length>0&&(_endCycle==null||_endCycle.length<=0)){
      print('起始+间隔');
      _endCycle=this.fetchEndCycle(_totalCycle,_spaceCycle);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time3', _endCycle);
      return;
    }
    //起始+到期
    if(_totalCycle.length>0&&(_spaceCycle.length<=0||_spaceCycle==null)&&_endCycle.length>0){
      print('起始+到期');
      _spaceCycle=this.fetchSpaceCycle(_totalCycle,_endCycle);
      notifyListeners();
      DDCacheUtil.cacheData('dd_plan_keep_time3', _spaceCycle);

      return;
    }
    //间隔+到期
    if((_totalCycle==null||_totalCycle.length<=0)&&_spaceCycle.length>0&&_endCycle.length>0){
      print('间隔+到期');
      _totalCycle=this.fetchStartCycle(_endCycle, _spaceCycle);
      notifyListeners();
      DDCacheUtil.cacheData('dd_start_time3', _totalCycle);
      return;
    }
    //更改
    if((_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle.length>0)&&trigger=='start'){
      print('==start');
      //起始更改，间隔不变，自动计算到期
      _endCycle=this.fetchEndCycle(_totalCycle,_spaceCycle);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time3', _endCycle);
      return;
    }
    if((_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle.length>0)&&trigger=='space'){
      print('==space');
      //间隔更改，起始不变，自动计算到期
      _endCycle=this.fetchEndCycle(_totalCycle,_spaceCycle);
      notifyListeners();
      DDCacheUtil.cacheData('dd_end_time3', _endCycle);

      return;
    }
    if((_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle.length>0)&&trigger=='end'){
      print('==end');
      //到期更改，起始不变，自动计算间隔
      _spaceCycle=this.fetchSpaceCycle(_totalCycle, _endCycle);
      notifyListeners();
      DDCacheUtil.cacheData('dd_plan_keep_time3', _spaceCycle);
      return;
    }
  }
  //=================================================循环动态计算==========================================
  void clearData(){
    _firstReportTime='';
    _startTime='';
    _space='';
    _endTime='';
    _totalHour='';//总飞行小时
    _spaceHour='';//间隔小时
    _endHour='';//到期小时
    _totalCycle='';//总飞行循环
    _spaceCycle='';//间隔循环
    _endCycle='';
    _canCalculate=null;
  }

  void clearTempData(){
    _day='';
    _hour='';
    _cycle='';
  }

  String get endCycle => _endCycle;

  String get spaceCycle => _spaceCycle;

  String get totalCycle => _totalCycle;

  String get endHour => _endHour;

  String get spaceHour => _spaceHour;

  String get totalHour => _totalHour;

  String get endTime => _endTime;

  String get space => _space;

  String get startTime => _startTime;

  String get firstReportTime => _firstReportTime;

  bool get canCalculate => _canCalculate;


  String get day => _day;

  String get hour => _hour;

  String get cycle => _cycle;

  setEndCycle(String value) {
    _endCycle = value;
  }

  setSpaceCycle(String value) {
    _spaceCycle = value;
  }

  setTotalCycle(String value) {
    _totalCycle = value;
  }

  setEndHour(String value) {
    _endHour = value;
  }

  setSpaceHour(String value) {
    _spaceHour = value;
  }

  setTotalHour(String value) {
    _totalHour = value;
  }

  setEndTime(String value) {
    _endTime = value;
  }

  setSpace(String value) {
    _space = value;
  }

  setStartTime(String value) {
    _startTime = value;
  }
  setFirstReportTime(String value) {
    _firstReportTime = value;
  }
  setCanCalculate(bool value) {
    _canCalculate = value;
  }

  setCycle(String value) {
    _cycle = value;
  }

  setHour(String value) {
    _hour = value;
  }

  setDay(String value) {
    _day = value;
  }
}