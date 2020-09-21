import 'dart:async';
import 'package:flutter/services.dart';
import 'package:zlmacaddress/zlmacaddress.dart';
import 'package:flutter/material.dart';
class MacAddressUtilProvide with ChangeNotifier{
  String _macAddress;
  String get macAddress=>_macAddress;
  String platformVersion;
  Future<String> getMacAddress() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Zlmacaddress.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    return platformVersion;
  }
  void myMacAddress(){
    getMacAddress().then((val){
      _macAddress=val;
      print('*****${val}=====${_macAddress}');
      notifyListeners();
    });

  }
}