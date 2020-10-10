import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/page/dd/operation_button_util.dart';
import 'package:lop/viewmodel/dd/ddlist_viewmodel.dart';
import 'package:provider/provider.dart';
typedef ValueChanged<T> = void Function(T value);
typedef SureBtnClick = void Function();
class DDDrawerWidget extends StatefulWidget {
  final String type;
  final ValueChanged valueChanged;
  final List textFieldNodes;
  final FocusNode numberFocusNode;
  final TextEditingController numberController;
  final FocusNode planeNoFocusNode;
  final TextEditingController planeNoController;
  final SureBtnClick  sureBtnClick;

  DDDrawerWidget(this.type,{this.valueChanged, this.textFieldNodes, this.numberFocusNode,
    this.numberController, this.planeNoFocusNode, this.planeNoController,this.sureBtnClick});
  @override
  _DDDrawerWidgetState createState() => _DDDrawerWidgetState();
}
class _DDDrawerWidgetState extends State<DDDrawerWidget> {

  String dropValue;
  DDListViewModel _listVM;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight+44),
      child: Column(
//      shrinkWrap: true,
        children: <Widget>[
          //编号
          DDComponent.tagImageAndTextField('search_dd_number', widget.numberFocusNode,widget.numberController,widget.textFieldNodes,imgStr: 'assets/images/ss1.png',),
          //飞机号
          DDComponent.tagImageAndTextField('search_dd_planeNo', widget.planeNoFocusNode,widget.planeNoController,widget.textFieldNodes,imgStr: 'assets/images/ss2.png',size: Size(21,21)),
          //状态
        (widget.type=='LB')? DDComponent.tagImageAndDropButton('search_dd_state', 180, [
            DropdownMenuItem(child: Text(Translations.of(context).text('un_close')),value: '0',),
            DropdownMenuItem(child: Text(Translations.of(context).text('closed')),value: '1'),
            DropdownMenuItem(child: Text(Translations.of(context).text('deleted')),value: '2'),
          ], dropValue,valueChanged: (val){
            dropValue=val;
            widget.valueChanged(val);
            setState(() {
            });
          },imgStr: 'assets/images/ss3.png',)
            :DDComponent.tagImageAndDropButton('search_dd_state', 180, [
            DropdownMenuItem(child: Text(Translations.of(context).text('un_close')),value: '0',),
            DropdownMenuItem(child: Text(Translations.of(context).text('closed')),value: '1'),
            DropdownMenuItem(child: Text(Translations.of(context).text('deleted')),value: '2'),
            DropdownMenuItem(child: Text(Translations.of(context).text('to_Audit')),value: '3',),
            DropdownMenuItem(child: Text(Translations.of(context).text('forTroubleShooting')),value: '4'),
            DropdownMenuItem(child: Text(Translations.of(context).text('for_inspection')),value: '5'),
            DropdownMenuItem(child: Text(Translations.of(context).text('have_transfer')),value: '6',),
            DropdownMenuItem(child: Text(Translations.of(context).text('has_delay')),value: '7'),
            DropdownMenuItem(child: Text(Translations.of(context).text('delay_close')),value: '8'),
          ], dropValue,valueChanged: (val){
            dropValue=val;
            widget.valueChanged(val);
            setState(() {
            });
          },imgStr: 'assets/images/ss3.png',),
          SizedBox(height: 20,),
            OperationButton.createButton('dd_sureButton', (){
              widget.sureBtnClick();
              //确认搜索
//              _listVM=Provider.of<DDListViewModel>(context,listen: false);
//              _listVM.getList(widget.type,all:false,page:'1',ddNo:widget.numberController.text,acReg: widget.planeNoController.text,state:dropValue);
//              Navigator.pop(context);
            },size: Size(double.infinity,120)),
        ],
      ),
    );
  }
}
