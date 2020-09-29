




  //极光推送测试绑定url
  const jPush_url = 'http://lmdpapp02.ameco.com.cn:9090/jpush/bind';

  const otherParameters = {
    "REQ":"XJSON"
  };

  // const servicePath = {
  //   'loginRequest':'LoginAction/Login.do',//登录url
  //   'fetchMyTaskInfoNew':'AirlineTaskAction/fetchMyTaskInfoNew.do',//获取当前人的任务数量
  //   'getTaskListByState':'AirlineTaskAction/getTaskListByState.do',//获取任务列表
  //   'GetJcHtmlPage':'LMJcAction/GetJcHtmlPage.do',//获取工卡页面
  //   'delSignData':'AirlineTaskAction/delSignData.do',//删除签署
  //   'downloadPhoto':'AirlineTaskAction/downloadPhoto.do',//下载图片
  //   'upLoadJcFile':'AirlineTaskAction/upLoadJcFile.do',//上传图片
  //   'getPhotoInfo':'AirlineTaskAction/getPhotoInfo.do',//查看图片
  //   'delPhoto':'AirlineTaskAction/delPhoto.do',//删除图片
  //   'searchMatList':'AirlineTaskAction/searchMatList.do',//搜索航材
  //   'searchMessageList':'AirlineTaskAction/getMsgList.do',//搜索消息
  //   'setMsgRead':'AirlineTaskAction/setMsgRead.do',//读取消息
  //   'getTaskAssignInfo':'AirlineTaskAction/getTaskAssignInfo.do',//获取任务详情
  //   'taskOperation':'AirlineTaskAction/taskOperation.do',//接收/领取任务
  //   'shiftWork':'AirlineTaskAction/shiftWork.do',//交班
  //   'getUnfinishInfo':'AirlineTaskAction/getUnfinishInfo.do',//放行时获取是否有其他任务未完成
  //   'assignTaskOperation':'AirlineTaskAction/assignTaskOperation.do',//任务操作
  //   'itemOperation':'AirlineTaskAction/itemOperation.do',//工卡任务操作
  //   'changePwdRequest':'MemberAction/changeOwnPassword.do',//修改密码
  //   'getAllTaskList':'AirlineTaskAction/getAllTaskList.do',//获取所有任务
  //   'getUnreadMsgCount':'AirlineTaskAction/getMsgCount.do',//获取未读消息数量
  // };
  class NetServicePath{
    static const String loginRequest = 'LoginAction/Login.do';//登录url
    static const String fetchMyTaskInfoNew = 'AirlineTaskAction/fetchMyTaskInfoNew.do';//获取当前人的任务数量
    static const String getTaskListByState = 'AirlineTaskAction/getTaskListByState.do';//获取任务列表
    static const String getJcHtmlPage ='LMJcAction/GetJcHtmlPage.do';//获取工卡页面
    static const String keyJobGetJcHtmlPage ='KeyJobAction/GetJcHtmlPage.do';//获取安全检查单页面
    static const String delSignData = 'AirlineTaskAction/delSignData.do';//删除签署
    static const String downloadPhoto = 'AirlineTaskAction/downloadPhoto.do';//下载图片
    static const String uploadJcFile = 'AirlineTaskAction/upLoadJcFile.do';//上传图片
    static const String getPhotoInfo = 'AirlineTaskAction/getPhotoInfo.do';//查看图片
    static const String delPhoto = 'AirlineTaskAction/delPhoto.do';//删除图片
    static const String searchMatList = 'AirlineTaskAction/searchMatList.do';//搜索航材
    static const String searchMessageList = 'AirlineTaskAction/getMsgList.do';//搜索消息
    static const String setMsgRead = 'AirlineTaskAction/setMsgRead.do';//读取消息
    static const String getTaskAssignInfo = 'AirlineTaskAction/getTaskAssignInfo.do';//获取任务详情
    static const String taskOperation = 'AirlineTaskAction/taskOperation.do';//接收/领取任务
    static const String shiftWork = 'AirlineTaskAction/shiftWork.do';//交班
    static const String getUnfinishInfo = 'AirlineTaskAction/getUnfinishInfo.do';//放行时获取是否有其他任务未完成
    static const String assignTaskOperation = 'AirlineTaskAction/assignTaskOperation.do';//任务操作
    static const String itemOperation = 'AirlineTaskAction/itemOperation.do';//工卡任务操作
    static const String changePwdRequest = 'MemberAction/changeOwnPassword.do';//修改密码
    static const String getAllTaskList = 'AirlineTaskAction/getAllTaskList.do';//获取所有任务
    static const String getUnreadMsgCount = 'AirlineTaskAction/getMsgCount.do';//获取未读消息数量
    static const String checkVersion = 'AppUpgradeAction/checkVersion.do';//检查更新
    static const String getSMSCode = 'SmsPasswordAction/sendMessageForNet.do';//获取验证码
    static const String resetPassword = 'SmsPasswordAction/restorePassword.do';//获取验证码

    //模块化工卡部分
    static const String getJcModuleInfo = 'AirlineTaskAction/getJcModuleInfo.do';//获取模块化工卡内容
    static const String getJcAssignModuleInfo = 'AirlineTaskAction/getJcAssignModuleInfo.do';//获取模块化工卡的签署信息
    //dd
    static const String ddListRequest = 'AcrDdlbAction/getAllDdListByApp.do';//dd列表

    static const String ddAddRequest = 'AcrDdlbAction/addDdlbByApp.do';//新增dd

    static const String ddDeleteRequest = 'AcrDdlbAction/delDdlbByApp.do';//删除dd
    static const String ddTransferRequest = 'AcrDdlbAction/lbToDdByApp.do';//dd转办
    static const String ddApproveRequest = 'AcrDdlbAction/approveDdByApp.do';//dd批准
    static const String ddDetailRequest = 'AcrDdlbAction/getDdInfoByApp.do';//dd详情
  }

  enum httpMethod{
    GET,
    POST,
    DELETE,
    PUT
  }
  const methodValues ={
    httpMethod.GET:"get",
    httpMethod.POST:"post",
    httpMethod.DELETE:"delete",
    httpMethod.PUT:"put"
  };

