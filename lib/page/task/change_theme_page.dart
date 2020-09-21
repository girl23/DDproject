import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/provide/theme_provider.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/style/theme/theme_config.dart';
import 'package:lop/utils/translations.dart';
import 'package:provider/provider.dart';

///
/// 修改主题的页面
///


class ChangeThemePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var themes = [
      AppTheme.themeValue_default,
      AppTheme.themeValue_orange,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text("theme")
        ,style: TextThemeStore.textStyleAppBar),
        centerTitle: true,
      ),
      body: ListView( //显示主题色块
        children: themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Container(
                color: (e == AppTheme.themeValue_orange)?KColor.primaryColor_2:KColor.primaryColor_1,
                height: 40,
              ),
            ),
            onTap: () {
              //主题更新后，MaterialApp会重新build
              ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
              themeProvider.setTheme(e);
            },
          );
        }).toList(),
      ),
    );
  }
}