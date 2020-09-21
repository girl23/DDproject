

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/locale_storage.dart';
import 'package:lop/style/theme/theme_config.dart';

class ThemeProvider extends AppTheme with ChangeNotifier{


  ThemeData get themeData {
    if(AppTheme.theme == null){
      Future _theme =  LocaleStorage.get('theme');
      _theme.then((value){
        AppTheme.theme = value;
      });
    }
    return AppTheme.getThemeData(AppTheme.theme);
  }

  setTheme(String newTheme){
    String oldTheme = AppTheme.theme;
    if(oldTheme == newTheme){
      return ;
    }
    LocaleStorage.set('theme', newTheme);
    AppTheme.theme = newTheme;
    print("newTheme = ${newTheme}");
    notifyListeners();
  }



}