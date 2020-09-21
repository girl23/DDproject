import 'package:lop/model/get_sms_code_model.dart';
import 'package:lop/model/jobcard/net_jc_module_info_model.dart';
import 'package:lop/model/reset_password_model.dart';
import 'package:lop/model/task_assign_jc_other.dart';
import 'package:lop/model/task_assign_task.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/model/task_state_list_model.dart';
import 'package:lop/model/task_state_num_model.dart';
import 'package:lop/model/user_model.dart';
import 'package:lop/model/material_list_model.dart';
import 'package:lop/model/message_list_model.dart';
import 'package:lop/model/version_model.dart';
import 'package:lop/model/base_response_model.dart';
import 'package:lop/model/change_password_model.dart';
import 'package:lop/model/message_unread_model.dart';

class EntityFactory{
  static T generateOBJ<T>(json){
    if(json == null){
      return null;
    }

    if(T.toString() == 'UserModel'){
      return UserModel.fromJson(json) as T;
    }

    if(T.toString() == 'TaskStateNumModel'){
      return TaskStateNumModel.fromJson(json) as T;
    }

    if(T.toString() == 'TaskStateListModel'){
      return TaskStateListModel.fromJson(json) as T;
    }

    if(T.toString() == 'MaterialListModel'){
      return MaterialListModel.fromJson(json) as T;
    }

    if(T.toString() == 'MessageListModel'){
      return MessageListModel.fromJson(json) as T;
    }

    if(T.toString() == 'TaskDetailModel'){
      return TaskDetailModel.fromJson(json) as T;
    }

    if(T.toString() == 'TaskAssignTask'){
      return TaskAssignTask.fromJson(json) as T;
    }

    if(T.toString() == 'TaskAssignJcOther'){
      return TaskAssignJcOther.fromJson(json) as T;
    }

    if(T.toString() == 'BaseResponseModel'){
      return BaseResponseModel.fromJson(json) as T;
    }
    if(T.toString() == 'ChangePwdModel'){
      return ChangePwdModel.fromJson(json) as T;
    }
    if(T.toString() == 'MessageUnreadModel'){
      return MessageUnreadModel.fromJson(json) as T;
    }
    if(T.toString() == 'VersionModel'){
      return VersionModel.fromJson(json) as T;
    }
    if(T.toString() == 'GetSmsCodeModel'){
      return GetSmsCodeModel.fromJson(json) as T;
    }
    if(T.toString() == 'ResetPasswordModel'){
      return ResetPasswordModel.fromJson(json) as T;
    }
    if(T.toString() == 'NetJcModuleInfoModel'){
      return NetJcModuleInfoModel.fromJson(json) as T;
    }
    return json as T;
  }
}