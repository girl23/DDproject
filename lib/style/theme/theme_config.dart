import 'package:flutter/material.dart';
import 'package:lop/config/locale_storage.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/theme/tabbar_theme.dart';
import 'package:lop/style/theme/text_theme.dart';

class AppTheme {
  static const themeValue_default = "themeDefault";
  static const themeValue_orange = "themeOrange";

  static String theme;

  static getThemeData(String value) {
    //theme_1:代表蓝色(默认主题)
    //theme_2:代表橙色
    ThemeData themData;

    if (value == themeValue_orange) {
      //
      themData = ThemeData(
        primaryColor: KColor.primaryColor_2,
        tabBarTheme: TabBarThemeStore.tabBarTheme_2,
        textTheme: TextThemeStore.textTheme_2,
        //flatbutton等使用
        buttonColor: KColor.primaryColor_2,
        highlightColor: KColor.color_f16703,

        primaryIconTheme: IconThemeData(color: KColor.textColor_white),
        cardTheme: CardTheme(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
    } else {
      themData = ThemeData(
        primaryColor: KColor.primaryColor_1,
        tabBarTheme: TabBarThemeStore.tabBarTheme_1,
        textTheme: TextThemeStore.textTheme_1,
        //flatbutton等使用
        buttonColor: KColor.primaryColor_1,
        highlightColor: KColor.color_0488e5,

        primaryIconTheme: IconThemeData(color: KColor.textColor_white),
        cardTheme: CardTheme(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
    }
    return themData;
  }

  static Future init() async {
    String _theme = await LocaleStorage.get('theme');
    theme = _theme;
//    if(_theme == null){
//      _theme = themeValue_default;
//    }
//    theme = _theme;
//    themeData = getThemeData(theme);
//    print("theme = ${theme}");
  }
}
