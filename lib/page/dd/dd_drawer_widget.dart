import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/page/dd/operation_button_util.dart';
typedef ValueChanged<T> = void Function(T value);
class DDDrawerWidget extends StatefulWidget {
  final ValueChanged valueChanged;
  final List textFieldNodes;
  final FocusNode numberFocusNode;
  final TextEditingController numberController;
  final FocusNode planeNoFocusNode;
  final TextEditingController planeNoController;

  DDDrawerWidget({this.valueChanged, this.textFieldNodes, this.numberFocusNode,
    this.numberController, this.planeNoFocusNode, this.planeNoController});
  @override
  _DDDrawerWidgetState createState() => _DDDrawerWidgetState();
}

class _DDDrawerWidgetState extends State<DDDrawerWidget> {
  String dropValue;
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight+44),
      child: Column(
//      shrinkWrap: true,
        children: <Widget>[
          //编号
          DDComponent.tagImageAndTextField('dd_number', widget.numberFocusNode,widget.numberController,widget.textFieldNodes,imgStr: 'assets/images/ss1.png',),
          //飞机号
          DDComponent.tagImageAndTextField('dd_planeNo', widget.planeNoFocusNode,widget.planeNoController,widget.textFieldNodes,imgStr: 'assets/images/ss2.png',size: Size(21,21)),
          //状态
          DDComponent.tagImageAndDropButton('dd_state', 180, [
            DropdownMenuItem(child: Text(Translations.of(context).text('dd_temporary_closed')),value: '已关闭',),
            DropdownMenuItem(child: Text(Translations.of(context).text('dd_temporary_unclosed')),value: '未关闭'),
            DropdownMenuItem(child: Text(Translations.of(context).text('dd_temporary_deleted')),value: '已删除'),
          ], dropValue,valueChanged: (val){
            dropValue=val;
            widget.valueChanged(val);
            setState(() {
            });
          },imgStr: 'assets/images/ss3.png',),
          SizedBox(height: 20,),
            OperationButton.createButton('dd_sureButton', (){
              //确认搜索
              Navigator.pop(context);
            },size: Size(double.infinity,120)),
        ],
      ),
    );
  }
}
