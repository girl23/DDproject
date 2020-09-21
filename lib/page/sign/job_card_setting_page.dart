import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/component/cyl_custom_slider.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/test_demo/table_test_page.dart';
import 'package:lop/utils/translations.dart';
import 'package:provider/provider.dart';
import 'package:lop/model/jc_sign_model.dart';


const itemHeight = 144;
const separatorHeight = 1;
const leftMargin = 25;

class JobCardSettingPage extends StatefulWidget {
  @override
  _JobCardSettingPageState createState() => _JobCardSettingPageState();
}

class _JobCardSettingPageState extends State<JobCardSettingPage> {

  List<SettingLanguageModel> settingLanguageModels;

  @override
  void initState() {
    JobCardLanguage defaultLanguage = Provider.of<JcSignModel>(context, listen: false).jcLanguage;
    settingLanguageModels = [
      SettingLanguageModel('中文', JobCardLanguage.cn, defaultLanguage == JobCardLanguage.cn),
      SettingLanguageModel('英文', JobCardLanguage.en, defaultLanguage == JobCardLanguage.en),
      SettingLanguageModel('中英文', JobCardLanguage.mix, defaultLanguage == JobCardLanguage.mix),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text('jobCard_setting_pageTitle'), style: TextStyle(fontSize: KFont.fontSizeAppBarTitle),),
      ),
      body: _body(),
      backgroundColor: KColor.pageBackGroundGreyColor,
    );
  }

  Widget _body(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(60),),
          Container(
            height: ScreenUtil().setHeight(itemHeight + separatorHeight) * 3,
            child: ListView.separated(itemBuilder: _itemBuilder, separatorBuilder: _separatorBuilder, itemCount: 3),
          ),
          SizedBox(height: ScreenUtil().setHeight(30),),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(leftMargin)),
            child: Text('字体大小设置',style: TextStyle(fontSize: KFont.fontSizeBtn_3),),
          ),
          SizedBox(height: ScreenUtil().setHeight(15),),
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CYLCustomSlider(
              Size(ScreenUtil.screenWidth, ScreenUtil().setHeight(220),),
                [1,1.25,1.5],
              Provider.of<JcSignModel>(context,listen: false).fontScale,
              onChange: (v){
                Provider.of<JcSignModel>(context,listen: false).fontScale = v;
              },
              canIndicatorDrag: false,
              labels: [
                Text('小', style: TextStyle(fontSize:KFont.fontSizeItem,color: Colors.black),),
                Text('', style: TextStyle(fontSize: KFont.fontSizeItem * 1.25,color: Colors.black),),
                Text('大', style: TextStyle(fontSize: KFont.fontSizeItem * 1.5,color: Colors.black),)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index){

    SettingLanguageModel model = settingLanguageModels[index];
    return GestureDetector(
      onTap: (){
        settingLanguageModels = settingLanguageModels.map((aModel){
          aModel.isSelect = false;
          return aModel;
        }).toList();
        model.isSelect = true;
        print(model);
        Provider.of<JcSignModel>(context, listen: false).jcLanguage = model.type;
        setState(() {});
      },
      child: Container(
        color:  Colors.white,
        constraints: BoxConstraints(minHeight: ScreenUtil().setHeight(itemHeight)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 9,
                child: Container(child: Text(model.title, style: TextStyle(fontSize: KFont.fontSizeBtn_2),),margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),)
            ),

            Expanded(
              flex: 1,
              child: Offstage(
                offstage: !model.isSelect,
                child: Icon(Icons.check,color: Colors.green,),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _separatorBuilder(BuildContext context, int index){
    return Divider(height: ScreenUtil().setHeight(separatorHeight), indent: ScreenUtil().setWidth(leftMargin),);
  }
}



class SettingLanguageModel {
  String title;
  JobCardLanguage type;
  bool isSelect;

  SettingLanguageModel(this.title, this.type, this.isSelect);

  @override
  String toString() {
    return 'SettingLanguageModel{title: $title, type: $type, isSelect: $isSelect}';
  }

}