import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lop/component/focus_widget.dart';




typedef void ITextFieldCallBack(String content,Key key);

enum ITextInputType {
  text,
  multiline,
  number,
  phone,
  datetime,
  emailAddress,
  url,
  password
}

class ITextField extends StatefulWidget {
  final ITextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final TextStyle hintStyle;
  final ITextFieldCallBack fieldCallBack;
  final Icon deleteIcon;
  final InputBorder inputBorder;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final bool showClear;
  final String inputText;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;

  ITextField({
    Key key,
    ITextInputType keyboardType: ITextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.fieldCallBack,
    this.deleteIcon,
    this.inputBorder,
    this.textStyle,
    this.showClear = false,
    this.prefixIcon, this.validator,
    this.inputText = "",
    this.focusNode
  })  : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ITextFieldState();
}

class _ITextFieldState extends State<ITextField> {
  String _inputText = "";
  bool _hasdeleteIcon = false;
  bool _isNumber = false;
  bool _isPassword = false;

  ///输入类型
  TextInputType _getTextInputType() {
    switch (widget.keyboardType) {
      case ITextInputType.text:
        return TextInputType.text;
      case ITextInputType.multiline:
        return TextInputType.multiline;
      case ITextInputType.number:
        _isNumber = true;
        return TextInputType.number;
      case ITextInputType.phone:
        _isNumber = true;
        return TextInputType.phone;
      case ITextInputType.datetime:
        return TextInputType.datetime;
      case ITextInputType.emailAddress:
        return TextInputType.emailAddress;
      case ITextInputType.url:
        return TextInputType.url;
      case ITextInputType.password:
        _isPassword = true;
        return TextInputType.text;
    }
  }

  ///输入范围
  List<TextInputFormatter> _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
      WhitelistingTextInputFormatter.digitsOnly,
    ]
        : null;
  }
  @override
  void initState() {
    super.initState();
    _inputText = widget.inputText;
  }

  @override
  void didUpdateWidget(ITextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _inputText = widget.inputText;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inputText = widget.inputText;
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new TextEditingController.fromValue(
        TextEditingValue(
            text: _inputText,
            selection: new TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: _inputText.length))));

    TextField textField = new TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onEditingComplete: (){
        widget.focusNode.unfocus();
      },
      decoration: InputDecoration(
        hintStyle: widget.hintStyle,
        counterStyle: TextStyle(color: Colors.white),
        hintText: widget.hintText,
        border: widget.inputBorder,
//        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightGreenAccent,width: 0.5),borderRadius: BorderRadius.only(
////          topLeft: Radius.circular(1.0),
////          topRight: Radius.circular(1.0),
////        )),
////        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.yellowAccent,width: 0.5),borderRadius: BorderRadius.only(
////          topLeft: Radius.circular(1.0),
////          topRight: Radius.circular(1.0),
////        )),
        fillColor: Colors.transparent,
        filled: true,
       // prefixIcon: widget.prefixIcon,
        suffixIcon: _hasdeleteIcon && widget.showClear
            ? new Container(
          width: 20.0,
          height: 20.0,
          child: new IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            iconSize: 18.0,
            icon: widget.deleteIcon != null
                ? widget.deleteIcon
                : Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _inputText = "";
                _hasdeleteIcon = (_inputText.isNotEmpty);
                widget.fieldCallBack(_inputText,context.widget.key);
              });
            },
          ),
        ): null,
      ),
      onChanged: (str) {
        setState(() {
          _inputText = str;
          _hasdeleteIcon = (_inputText.isNotEmpty);
          widget.fieldCallBack(_inputText,context.widget.key);
        });
      },
      autofocus: false,
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: _isPassword,
    );
    return FocusWidget(
      focusNode: widget.focusNode,
      child: textField,
    );
  }
}