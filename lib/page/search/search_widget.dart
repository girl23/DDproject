import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/style/theme/text_theme.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final Function onClear;
  final FocusNode focusNode;

  SearchField({Key key, this.hintText,this.controller, this.onSubmitted,this.onClear, this.focusNode})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  bool _isShowClear = false;

  @override
  void initState() {
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveController.addListener(_handleControllerChanged);

    super.initState();
  }

  @override
  void dispose() {

    _effectiveController?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text.length > 0) {
      _isShowClear = true;
    } else {
      _isShowClear = false;
    }

    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(120),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
      ),
      child: new Row(
        children: <Widget>[
          SizedBox(
            width: ScreenUtil().setWidth(20.0),
          ),

          Icon(
            Icons.search,
            color: Colors.grey,
            size: ScreenUtil().setSp(70),
          ),

          SizedBox(
            width: ScreenUtil().setWidth(15.0),
          ),

          Expanded(
            child: Container(
              child: TextField(
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: TextThemeStore.textStyleSearch.fontSize, color: TextThemeStore.textStyleSearch.color),
                controller: _effectiveController,
                focusNode: widget.focusNode,
                textAlign: TextAlign.left,
                decoration: new InputDecoration(
                    hintText: widget.hintText,
                    isDense: true,
                    hintStyle:
                    TextStyle(
                        fontSize: TextThemeStore.textStyleSearch.fontSize,
                        textBaseline: TextBaseline.alphabetic
                    ),
                    border: InputBorder.none),
                // onChanged: onSearchTextChanged,
                onSubmitted: widget.onSubmitted,
                autofocus: false,
              ),
            ),
          ),
          _isShowClear?IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.clear,
              size: ScreenUtil().setSp(60),
            ),
            color: Colors.grey,
            onPressed: () {
              _effectiveController.clear();
              if(widget.onClear != null) widget.onClear();
            },
          ):Container(),
        ],
      ),
    );

  }
}
