import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../component/listflodexpand/expand_state_bean.dart';
import '../component/loading_view/loading_view_controller.dart';
import '../component/sectionlist/item_position.dart';
import '../config/configure.dart';
import '../config/enum_config.dart';
import '../config/global.dart';
import 'package:lop/config/locale_storage.dart';
import 'package:lop/database/jc_data_db_model.dart';
import 'package:lop/database/jc_data_db_tools.dart';
import 'package:lop/database/jc_info_db_model.dart';
import 'package:lop/database/jc_info_db_tools.dart';
import 'package:lop/model/jobcard/jc_model.dart';
import 'package:lop/model/jobcard/net_jc_module_info_model.dart';
import 'package:lop/model/jobcard/task_item_position.dart';
import 'package:lop/model/jobcard/xml_parse.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/service/jobcard/job_card_service.dart';
import 'package:lop/service/jobcard/job_card_service_impl.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'jobcard/jc_body_model.dart';
import 'jobcard/job_card_model.dart';

class JcSignModel with ChangeNotifier {

  JobCardService _service = JobCardServiceImpl();

  //签署类型
  String signType;

  //签署的工卡id
  int jcId;

  //签署语法location位置
  String location;

  //签署ID，可能是批签就有多个
  String signId;

  //工序id,批签为多个
  String posId;

  //签署还是预览,1为签署，0为预览
  int isSign;

  //工卡还是安全检查单 true 为安全检查单 false为工卡
  bool isJobType = false;

  //签署页面标题 工卡号+工卡标题
  String signTitle;
  BuildContext _context;

  //签名图片
  Map<String, String> signPics = Map();

  //动态数据
  DynamicDataModel dynamicDataModel;

  //工卡数据
  JobCardModel jobCardModel;

  //工卡数据：需要显示的模块，对应的工序列表数据。JcModel——>ProcedureModel
  List<JcModel> procedureList = [];

  //语言
  JobCardLanguage jcLanguage;
  ProgressDialog _loadingDialog;

  //条目path
  String itemPath;

  //模块选择状态
  List<ModuleSelectStateBean> moduleSelectStatus = [];
  bool moduleSelectDidChange = false;

  //条目图片显示宽度
  double contentImageWidth = 0.0;
//  Map<int,TaskItemPosition> itemHeightRecord = {};



  void initApi(context) {
    _context = context;
//    _invokeNativeMethod('initApi',
//        '${Provider.of<UserViewModel>(_context, listen: false).info.userId}:${Provider.of<UserViewModel>(_context, listen: false).info.realName}:${jcId}');
//    Global.signMessageChannel.setMessageHandler(receiveHandler);

    _readJobCardLanguageSetting(context);
    dynamicDataModel = DynamicDataModel();
  }

  void _showProgress() async {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialogUtil.createProgressDialog(_context);
    }
    await _loadingDialog.show();
  }

  void show() async {
    naSignChoose.forEach((value) {
      changeCheckValue(itemPath: value, value: false);
      notifyChangeCheck();
    });
    bool showDialog = false;
    for (int i = 0; i < naSignChoose.length; i++) {
      showDialog = await dynamicDataModel.showDialog(itemPath: naSignChoose[i]);
      if (showDialog) break;
    }
    if (showDialog) {
      horizontalDoubleButtonDialog(_context,
          title: '提示",info: "是否将N/A签署条目的输入框内容变为"/"',
          leftText: "取消",
          rightText: "确定",
          onTapLeft: () {}, onTapRight: () {
        naSignChoose.forEach((value) {
          changeInputValue(itemPath: value, value: "/");
          notifyChangeInput();
        });
        _invokeMethod();
      });
    } else {
      naSignChoose.forEach((value) {
        changeInputValue(itemPath: value, value: "/");
        notifyChangeInput();
      });
      _invokeMethod();
    }
  }

  void _invokeMethod() {
    _showProgress();
    _invokeNativeMethod('show', 'posid:${jcId}:${posId}:${signId}');
  }

  ///调用原生方法
  ///method 原生方法名
  ///args 发送原生的参数
  void _invokeNativeMethod(String methodName, dynamic args) async {
//    if (Platform.isIOS) {
//      //IOS未实现
//      return;
//    }
    try {
      var result =
          await Global.signMethodChannel.invokeMethod(methodName, args);
    } catch (e) {
      print(e);
    }
  }

  ///接收原生消息
  ///message 为json格式{'eventName':'','eventData':''}
  Future<dynamic> receiveHandler(dynamic message) async {
    print(message);
    var json = jsonDecode(message);
    String eventName = json['eventName'];
    String eventData = json['eventData'];
    switch (eventName) {
      case 'AndroidToRNMessage':
      case 'iOSToRNMessage':
        _successSign(eventData);
        break;
      case 'ErrorToRNMessage':
        _errorSign(eventData);
        break;
      case 'AndroidToRNMessageLog':
      case 'iOSToRNMessageLog':
        print(message);
        _loadingDialog.hide();
        break;
      case 'AndroidDeleteSign':
      case 'iOSDeleteSign':
        _successDelete(eventData);
        break;
    }

    return 'Receive Success';
  }

  void _successDelete(String eventData) {
    var datas = eventData.split(':');
    var signId = datas[1];
    var key = "";
    if (signId == "102901206") {
      key = "000001000001000001";
    } else if (signId == "102901207") {
      key = "000001000001000002";
    } else if (signId == "102901208") {
      key = "000001000002000001";
    } else if (signId == "102901209") {
      key = "000002000001000001";
    }
    if (signPics.containsKey(key)) {
//          _jcSignModel.signPics[key] = 'base64:${signIdArr[i]}:$eventData:${locationArr[i]}';
      signPics.remove(key);
      signChange();
    }
    _loadingDialog.hide();
  }

  void _successSign(String eventData) {
    //完工签署
    if (signType == "jc") {
      //调用js方法
      Provider.of<TaskDetailStateProvide>(_context, listen: false)
          .updateTaskDetail(_context);
      return;
    }
    //工序签署
    if (location.indexOf(',') > 0) {
      //批签。有位置顺序
      var locationArr = location.split(',');
      var signIdArr = signId.split(',');
      for (var i = 0; i < locationArr.length; i++) {
        //修改item显示
        var key = "";
        if (signIdArr[i] == "102901206") {
          key = "000001000001000001";
        } else if (signIdArr[i] == "102901207") {
          key = "000001000001000002";
        } else if (signIdArr[i] == "102901208") {
          key = "000001000002000001";
        } else if (signIdArr[i] == "102901209") {
          key = "000002000001000001";
        }
//          _jcSignModel.signPics[key] = 'base64:${signIdArr[i]}:$eventData:${locationArr[i]}';
        signPics[key] = eventData;
        signChange();
      }
    } else {
      //单签//修改item显示
      var key1 = "";
      if (signId == "102901206") {
        key1 = "000001000001000001";
      } else if (signId == "102901207") {
        key1 = "000001000001000002";
      } else if (signId == "102901208") {
        key1 = "000001000002000001";
      } else if (signId == "102901209") {
        key1 = "000002000001000001";
      }

//          _jcSignModel.signPics[key] = 'base64:${signIdArr[i]}:$eventData:${locationArr[i]}';
      signPics[key1] = eventData;
      signChange();
    }
    _loadingDialog.hide();
  }

  void _errorSign(String eventData) {
    print("_errorSign :$signType");
    if (signType == 'jc') {
      ToastUtil.makeToast("error:$jcId",
          toastType: ToastType.ERROR, gravity: ToastGravity.CENTER);
    } else if (signType == 'pos') {
      ToastUtil.makeToast("error:$location",
          toastType: ToastType.ERROR, gravity: ToastGravity.CENTER);
    }
    _loadingDialog.hide();
  }

  void deleteSign(String key) async {
    var signId = "";
    var location = "";
    if (key == "000001000001000001") {
      signId = "102901206";
      location = "28006";
    } else if (key == "000001000001000002") {
      signId = "102901207";
      location = "28009";
    } else if (key == "000001000002000001") {
      signId = "102901208";
      location = "28010";
    } else if (key == "000002000001000001") {
      signId = "102901209";
      location = "28007";
    }
    print(
        "jcId: $jcId signId:$signId userid:${Provider.of<UserViewModel>(_context, listen: false).info.userId} token:${Provider.of<UserViewModel>(_context, listen: false).info.token} location:$location");
    _showProgress();
    DioManager()
        .request(httpMethod.GET, NetServicePath.delSignData, null, params: {
      "jcid": jcId,
      'signid': signId,
      'userid': Provider.of<UserViewModel>(_context, listen: false).info.userId,
      'signtype': "delpossign",
      "udfuserid":
          Provider.of<UserViewModel>(_context, listen: false).info.userId,
      "token": Provider.of<UserViewModel>(_context, listen: false).info.token
    }, success: (data) {
      print(data);
      if (data['result'] == 'success') {
        _invokeNativeMethod('deleteSign', 'deleteesign:${signId}:${location}');
        //deleteesign:${signId}:${location}
      } else {
        _invokeNativeMethod('deleteSign', 'error:${location}');
        //error:${location}
        _invokeNativeMethod('toastShow', data['info']);
      }
    });
  }

  void modifySign(String key) async {
    if (key == "000001000001000001") {
      signId = "102901206";
      posId = "97222993";
      location = "28006";
    } else if (key == "000001000001000002") {
      signId = "102901207";
      posId = "97222993";
      location = "28009";
    } else if (key == "000001000002000001") {
      signId = "102901208";
      posId = "97222993";
      location = "28010";
    } else if (key == "000002000001000001") {
      signId = "102901209";
      posId = "97222993";
      location = "28007";
    }
    show();
  }

  //字体的放大倍数
  double _fontScale = 1.0;

  bool _drawerisDragable = true;

  bool get drawerisDragable => _drawerisDragable;

  set drawerisDragable(bool value) {
    _drawerisDragable = value;
    notifyListeners();
  }

  double get fontScale => _fontScale;

  set fontScale(double value) {
    if (_fontScale != value) {
      _fontScale = value;
      notifyListeners();
    }
  }

  LoadingViewController _controller;

  set loadingViewController(LoadingViewController controller) {
    _controller = controller;
  }

  /// 条目选择签署的数据
  List<String> _naSignChoose = []; //NA签署
  List<String> get naSignChoose => _naSignChoose;

  List<String> _normalSignChoose = []; //普通签署
  List<String> get normalSignChoose => _normalSignChoose;

  ValueNotifier<bool> signChooseListener = ValueNotifier(false);
  ValueNotifier<bool> signChangeListener = ValueNotifier(false);
  ValueNotifier<bool> inputChangeListener = ValueNotifier(false);
  ValueNotifier<bool> checkChangeListener = ValueNotifier(false);
  ValueNotifier<bool> radioChangeListener = ValueNotifier(false);
  void signChange() {
    signChangeListener.value = !signChangeListener.value;
  }

  void naSignChooseChange(String id, bool isCheck) {
    if (isCheck) {
      _naSignChoose.add(id);
      _normalSignChoose.remove(id);
    } else {
      _naSignChoose.remove(id);
    }
    signChooseListener.value = !signChooseListener.value;
  }

  void normalSignChooseChange(String id, bool isCheck) {
    if (isCheck) {
      _normalSignChoose.add(id);
      _naSignChoose.remove(id);
    } else {
      _normalSignChoose.remove(id);
    }
    signChooseListener.value = !signChooseListener.value;
  }


  ///
  /// 页面的初始数据入口
  ///
  void startJcPageData(BuildContext context) async{
    assert(jcId != null, 'jcId 不能为null。');
    _controller?.state = LoadingState.loading;

    bool success = await _startLoadJcBasicData();
    if(success){
      _controller?.state = LoadingState.success;
      notifyListeners();
    }else{
      _controller?.state = LoadingState.error;
    }
  }


  ///
  /// 获取工卡基本数据
  ///
  Future<bool> _startLoadJcBasicData() async {
    print('JcSignModel._startLoadJcBasicData()：开始处理工卡的基本数据内容');
    // 1、查询工卡在数据库里的信息
    JcInfoDbModel jcInfoModel;
    bool hadJcData = await JcDataDbTools().hadJobCardData(jcId);
    if (hadJcData) {
      jcInfoModel = await JcInfoDbTools().queryJobCard(jcId);
    }
    // 2、请求服务器，查询工卡数据的版本号等内容
    Map<String, String> resMap = await _getJcXmlDataFromServer(jcInfoModel);
    bool isError = resMap['isError']=='true'?true:false;
    if(isError){
      print('JcSignModel._startLoadJcBasicData()：网络获取工卡信息异常！');
      return false;
    }
    bool needUpdate = resMap['needUpdate']=='true'?true:false;
    if(needUpdate){
      String version = resMap['version'];
      //解析xml内容并存入数据到数据库
      jobCardModel = await _parseJcDataAndSaveDb(jcId, resMap['data']);
      //更新版本信息
      _saveJcInfoToDb(jcId, version);
    }else{
      //解析数据库中的数据
      jobCardModel = await _getJobCardModelFromDb(jcId);
    }
    //3、抽离数据，将工序抽离成列表，供右侧导航使用
    procedureList = _formProcedureListData();
    print('JcSignModel._startLoadJcBasicData()：处理工卡基本数据成功');
    return true;
  }

  ///
  /// 请求后台获取最新的数据信息
  ///
  Future<Map<String, String>> _getJcXmlDataFromServer(JcInfoDbModel jcInfoDbModel) async {
    bool needUpdate = false;
    String data = '';
    String newVersion = '';
    String version = jcInfoDbModel?.version;
    bool isError = false;
    /// 请求服务器查询当前工卡的基本信息
    NetworkResponse response = await _service.getJcModuleInfo(jcId: this.jcId, jcVersion: version);
    if(response.isSuccess){
      NetJcModuleInfoModel model = response.data;
      if(model.jcVersion != null && model.jcVersion != '' && model.jcVersion != version){
        //需要更新内容：版本号不一致
        needUpdate = true;
        data = model.xmlContent;
        newVersion = model.jcVersion;
      }
    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      isError = true;
    }
    return {
      'needUpdate':needUpdate.toString(),
      'version':newVersion,
      'data':data,
      'isError':isError.toString()
    };
  }

  Future<void> _saveJcInfoToDb(int jcId, String version) async {
    JcInfoDbModel infoDbModel = await JcInfoDbTools().queryJobCard(jcId);
    if (infoDbModel == null) {
      await JcInfoDbTools().addJobCard(jcId, version);
    } else {
      await JcInfoDbTools().updateJobCard(jcId, version);
    }
  }

  Future<JobCardModel> _parseJcDataAndSaveDb(int jcId, String data) async {
    JobCardModel jobCardModel =
        await XMLParse().xmlParseHoleJobCard(data, needRawStr: true);

    List<JcDataDbModel> saveList = [];
    if (jobCardModel.headerModel != null) {
      JcDataDbModel jcDataDbModel = JcDataDbModel();
      jcDataDbModel.jcId = jcId;
      jcDataDbModel.type = JcDataDbModel.jcDataDbTypeHeader;
      jcDataDbModel.data = jobCardModel.headerModel.rawData;
      saveList.add(jcDataDbModel);
    }

    if (jobCardModel.bodyModel != null &&
        jobCardModel.bodyModel.children != null &&
        jobCardModel.bodyModel.children.isNotEmpty) {
      for (ModuleModel moduleModel in jobCardModel.bodyModel.children) {
        JcDataDbModel jcDataDbModel = JcDataDbModel();
        jcDataDbModel.jcId = jcId;
        jcDataDbModel.type = JcDataDbModel.jcDataDbTypeModel;
        jcDataDbModel.modelNo = int.parse(moduleModel.no);
        jcDataDbModel.data = moduleModel.rawData;
        saveList.add(jcDataDbModel);
      }
    }

    if (jobCardModel.figureModel != null) {
      JcDataDbModel jcDataDbModel = JcDataDbModel();
      jcDataDbModel.jcId = jcId;
      jcDataDbModel.type = JcDataDbModel.jcDataDbTypeFigure;
      jcDataDbModel.data = jobCardModel.figureModel.rawData;
      saveList.add(jcDataDbModel);
    }
    await JcDataDbTools().deleteJobCardAllData(jcId);
    await JcDataDbTools().addJobCardDataList(saveList);
    return jobCardModel;
  }

  Future<JobCardModel> _getJobCardModelFromDb(int jcId) async {
    JobCardModel jobCardModel = JobCardModel();
    //header
    List<JcDataDbModel> headerList = await JcDataDbTools()
        .queryJobCardDataByType(jcId, JcDataDbModel.jcDataDbTypeHeader);
    if (headerList != null && headerList.isNotEmpty) {
      JcDataDbModel dbHeaderModel = headerList.first;
      jobCardModel.headerModel = XMLParse().parseXmlHeader(dbHeaderModel.data);
    }
    //body
    List<JcDataDbModel> moduleList = await JcDataDbTools()
        .queryJobCardDataByType(jcId, JcDataDbModel.jcDataDbTypeModel);
    if (moduleList != null && moduleList.isNotEmpty) {
      BodyModel bodyModel = BodyModel();
      for (JcDataDbModel jcDataDbModel in moduleList) {
        ModuleModel moduleModel =
            XMLParse().parseModuleModel(jcDataDbModel.data);
        bodyModel.addChild(moduleModel);
      }
      jobCardModel.bodyModel = bodyModel;
    }
    //figure
    List<JcDataDbModel> figureList = await JcDataDbTools()
        .queryJobCardDataByType(jcId, JcDataDbModel.jcDataDbTypeFigure);
    if (figureList != null && figureList.isNotEmpty) {
      JcDataDbModel dbFigureModel = figureList.first;
      jobCardModel.figureModel =
          XMLParse().parseFigureModel(dbFigureModel.data);
    }
    return jobCardModel;
  }

  ///
  /// 组织工序列表数据，用于左侧内容区域展示内容。
  ///
  /// TODO：内容根据工卡状态、用户选择、用户上次的浏览记录综合决定, 初始化[moduleSelectStatus]存着模块选择的状态
  ///
  List<JcModel> _formProcedureListData() {
    List<JcModel> list = [];
    if (jobCardModel != null) {
      List<JcModel> moduleList = jobCardModel.bodyModel?.children;
      if (moduleList != null && moduleList.isNotEmpty) {
        int moduleIndex = 0;
        for (JcModel jcModel in moduleList) {
          ModuleModel moduleModel = jcModel;
          int listLength = list.length;
          if (moduleModel.children != null && moduleModel.children.isNotEmpty) {
            for(ProcedureModel pm in moduleModel.children){
              pm.modelIndex = moduleIndex;
              list.add(pm);
            }
          }
          moduleSelectStatus.add(ModuleSelectStateBean(moduleIndex, true,list.length - listLength));
          moduleIndex += 1;
        }
      }
    }
    return list;
  }

  void moduleSelectStatusDidChange(){
    moduleSelectDidChange = true;
    procedureList.clear();
    List<JcModel> moduleList = jobCardModel.bodyModel?.children;
    for(int index = 0; index < moduleList.length; index++){
      ModuleSelectStateBean selStatus = moduleSelectStatus[index];
      if(selStatus.isSelect){
        ModuleModel moduleModel = moduleList[index];
        if (moduleModel.children != null && moduleModel.children.isNotEmpty) {
          procedureList.addAll(moduleModel.children);
        }
      }
    }

  }

  ///
  /// 读取语言设置信息
  ///
  void _readJobCardLanguageSetting(BuildContext context) async {
    String language = await LocaleStorage.get('jobCardLanguage');
    if (language == null) {
      //根据系统语言决定
      Locale locale = Translations.of(context).locale;
      String value = '1';
      if ('zh' == locale.languageCode) {
        jcLanguage = JobCardLanguage.cn;
        value = '0';
      } else {
        jcLanguage = JobCardLanguage.en;
      }
      await LocaleStorage.set('jobCardLanguage', value);
    } else {
      int l = int.parse(language);
      jcLanguage = (l == 0)
          ? JobCardLanguage.cn
          : ((l == 1) ? JobCardLanguage.en : JobCardLanguage.mix);
    }
  }

  void changeInputValue({@required itemPath, @required value}) {
    dynamicDataModel.changeInputValue(itemPath: itemPath, value: value);
  }

  void notifyChangeInput() {
    inputChangeListener.value = !inputChangeListener.value;
  }

  Future<bool> showDialog({@required itemPath}) async {
    return await dynamicDataModel.showDialog(itemPath: itemPath);
  }

  Future<void> changeCheckValue({@required itemPath, @required value}) async {
    await dynamicDataModel.changeCheckValue(itemPath: itemPath, value: value);
  }

  void notifyChangeCheck() {
    checkChangeListener.value = !checkChangeListener.value;
  }
  void notifyChangeRadio() {
    radioChangeListener.value = !radioChangeListener.value;
  }
  ///
  /// 销毁
  ///

  @override
  void dispose() {
    signChooseListener.dispose();
    super.dispose();
  }
}

class DynamicDataModel {
  Map<String, _DynamicData> _dynamicData = Map();

  Future<bool> showDialog({@required itemPath}) async {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      return await data.showDialog();
    }
    return false;
  }

  Future<void> changeInputValue({@required itemPath, @required value}) async {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      await data.changeInputValue(value);
    }
  }

  Future<void> changeCheckValue({@required itemPath, @required value}) async {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      await data.changeCheckValue(value);
    }
  }

  String inputValue({@required itemPath, @required path}) {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      return data.inputValue(path);
    }
    return "";
  }

  bool checkValue({@required itemPath, @required dbId}) {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      return data.checkValue(dbId);
    }
    return false;
  }
  String radioValue({@required itemPath, @required group}){
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      return data.radioValue(group);
    }
    return "";
  }
  void setInputValue({@required itemPath, @required path, @required value}) {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      data.setInputValue(path, value);
    } else {
      _DynamicData data = _DynamicData();
      data.setInputValue(path, value);
      _dynamicData[itemPath] = data;
    }
  }

  void setCheckValue({@required itemPath, @required dbId, @required value}) {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      data.setCheckValue(dbId, value);
    } else {
      _DynamicData data = _DynamicData();
      data.setCheckValue(dbId, value);
      _dynamicData[itemPath] = data;
    }
  }
  void setRadioValue({@required itemPath, @required group, @required value}) {
    if (_dynamicData.containsKey(itemPath)) {
      _DynamicData data = _dynamicData[itemPath];
      data.setRadioValue(group, value);
    } else {
      _DynamicData data = _DynamicData();
      data.setRadioValue(group, value);
      _dynamicData[itemPath] = data;
    }
  }
}

class _DynamicData {
  Map<String, String> _inputData = Map();
  Map<String, bool> _checkData = Map();
  Map<String, String> _radioData = Map();
  Future<bool> showDialog() async {
    bool isShow = false;
    _inputData.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        isShow = true;
      }
    });
    return isShow;
  }

  Future<void> changeCheckValue(bool newValue) async {
    _checkData.forEach((key, value) {
      _checkData[key] = newValue;
    });
  }

  Future<void> changeInputValue(String newValue) async {
    _inputData.forEach((key, value) {
      _inputData[key] = newValue;
    });
  }

  String inputValue(String key) {
    if (_inputData.containsKey(key)) {
      return _inputData[key];
    }
    return "";
  }

  bool checkValue(String dbId) {
    if (_checkData.containsKey(dbId)) {
      return _checkData[dbId];
    }
    return false;
  }

  String radioValue(String key){
    if(_radioData.containsKey(key)){
      return _radioData[key];
    }
    return "";
  }

  void setInputValue(String key, String value) {
    _inputData[key] = value;
  }

  void setCheckValue(String key, bool value) {
    _checkData[key] = value;
  }

  void setRadioValue(String key,String value){
    _radioData[key] = value;
  }

}
