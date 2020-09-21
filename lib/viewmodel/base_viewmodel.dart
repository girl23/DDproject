import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/global.dart';
abstract class BaseViewModel{
static  BuildContext appContext =Global.navigatorKey.currentContext;
BuildContext context;
//  BuildContext appContext=Global.navigatorKey.currentState.context;
//    BuildContext appContext=Global.navigatorKey.currentState.overlay.context;
}