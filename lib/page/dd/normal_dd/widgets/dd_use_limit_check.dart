import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/style/size.dart';
import 'package:lop/page/dd/component/dd_component.dart';
typedef ValueChanged<T> = void Function(T value);
class UseLimit extends StatefulWidget {
  final List textFieldNodes;
  final ValueChanged valueChangedForO;
  final ValueChanged valueChangedForOther;
  final bool checkValueOOption;
  final bool checkValueOtherOption;
  final FocusNode otherNode;
  final TextEditingController otherController;
  UseLimit({this.valueChangedForO,this.valueChangedForOther,this.checkValueOOption,this.checkValueOtherOption,this.otherNode,this.otherController,bool fromTempDD,this.textFieldNodes});
  @override
  _UseLimitState createState() => _UseLimitState();
}

class _UseLimitState extends State<UseLimit> {
  bool oOption;
  bool otherOption;
  bool oUpdate=false;
  bool otherUpdate=false;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.only(left: 15),
//              alignment: Alignment.centerLeft,
//              child:Text(Translations.of(context).text('dd_other'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
//            ),
            DDComponent.tagAndCheckBoxLeft('dd_o',100, oUpdate?oOption:widget.checkValueOOption,valueChanged: (value){
              oUpdate=true;
              oOption=value;
              widget.valueChangedForO(value);
              setState(() {
              });
            }),
            Container(
                height: KSize.textFieldHeight,
                child:
                Row(
                  children: <Widget>[
                    DDComponent.tagAndCheckBoxLeft('dd_other', 100, otherUpdate?otherOption:widget.checkValueOtherOption,valueChanged: (value){
                      otherUpdate=true;
                      otherOption=value;
                      widget.valueChangedForOther(value);
                      setState(() {
                      });
                    }),
                    Expanded(
                      child:DDComponent.tagAndTextField('dd_other_describe', 0, widget.otherNode,  widget.otherController, widget.textFieldNodes)
                    )

                  ],
                ))
          ]
      ),
    );
  }
}
