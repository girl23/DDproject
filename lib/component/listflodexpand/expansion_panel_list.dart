import 'package:flutter/material.dart';
import 'package:lop/style/size.dart';
import 'expand_icon_widget.dart' as iconBtn;

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension; //48

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);
  final S salt;
  final V value;
  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);
  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

typedef ExpansionPanelCallback = void Function(int panelIndex, bool isExpanded);
typedef ExpansionPanelHeaderBuilder = Widget Function(
    BuildContext context, bool isExpanded);
typedef CheckBoxCallback = void Function(int indx, bool isSelect);

class ExpansionPanel {
  ExpansionPanel({
    @required this.headerBuilder,
    @required this.body,

    this.isExpanded = false,
    this.isSelect = false,
    this.canTapOnHeader = false,
  })  : assert(headerBuilder != null),
        assert(body != null),
        assert(isExpanded != null),
        assert(canTapOnHeader != null);

  final ExpansionPanelHeaderBuilder headerBuilder;

  final Widget body;

  final bool isExpanded;
  final bool isSelect;

  final bool canTapOnHeader;


}

class ExpansionPanelList extends StatefulWidget {
  const ExpansionPanelList({
    Key key,
    this.processCompleteList,
    this.children = const <ExpansionPanel>[],
    this.expansionCallback,
    this.checkBoxCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.hasDividers = false,
    this.icon,
  })  : assert(children != null),
        assert(animationDuration != null),
        super(key: key);

  final List<ExpansionPanel> children;

  final ExpansionPanelCallback expansionCallback;

  final CheckBoxCallback checkBoxCallback;

  final Duration animationDuration;

  final bool hasDividers;

  final Icon icon;

  final List processCompleteList;

  @override
  State<StatefulWidget> createState() => _ExpansionPanelListState();
}

class _ExpansionPanelListState extends State<ExpansionPanelList> {
  final GlobalKey progressBackGroundKey = GlobalKey();
  //查看当前节点是否是展开的
  bool _isChildExpanded(int index) {
    return widget.children[index].isExpanded;
  }

  //点击回调
  void _handlePressed(bool isExpanded, int index) {
    if (widget.expansionCallback != null)
      widget.expansionCallback(index, isExpanded);
  }

  bool _isChildSelect(int index) {
    return widget.children[index].isSelect;
  }

  //点击复选框回调
  void _handleCheckBoxPressed(bool isExpanded, int index) {
    if (widget.checkBoxCallback != null)
      widget.checkBoxCallback(index, isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraits) {
        return _build(context, constraits.maxWidth);
      },
    );
  }

  Widget _build(BuildContext context, double drawerWidth) {
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];
    //存储进度条的颜色
    List<Color> progressColor = [];

    for (int index = 0; index < widget.children.length; index += 1) {
      switch (index) {
        case 0:
          progressColor.add(Color(0xffFCED74));
          break;
        case 1:
          progressColor.add(Color(0xff4AE5CE));
          break;
        case 2:
          progressColor.add(Color(0xff74FF7E));
          break;
        case 3:
          progressColor.add(Color(0xff74AEFE));
          break;
        case 4:
          progressColor.add(Color(0xffED88EE));
          break;
        default:
          progressColor.add(Color(0xffFCED74));

          break;
      }
      final ExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(
        context,
        _isChildExpanded(index),
      );
      //复选框
      Widget checkIconContainer = Container(
        height: _kPanelHeaderCollapsedHeight,
        alignment: Alignment.center,
        child: iconBtn.CheckIcon(
            isSelect: _isChildSelect(index),
            valueChanged: (bool isSelect) => _handleCheckBoxPressed(
                isSelect, index) //_handlePressed(isExpanded, index)
            ),
      );
      //图标
      Widget expandIconContainer = Container(
        color: Colors.transparent,
        child: iconBtn.ExpandIcon(
          isExpanded: _isChildExpanded(index), onPressed: (bool value) {},
//            valueChanged:(bool isExpanded) => _handlePressed(isExpanded, index)
        ),
      );
      //头部布局
      Widget headerWidgetWithIndex(int index) {
        //复选框
        return Container(
          padding: EdgeInsets.only(bottom: KSize.commonPadding3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: checkIconContainer,
              ),
              Expanded(
                  flex: 13,
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                height: _kPanelHeaderCollapsedHeight - 8,
                                child: Row(
                                  children: <Widget>[
                                    //图标
                                    Container(
                                      width: 16,
                                      child: expandIconContainer,
                                    ),
                                    //内容
                                    Expanded(
                                      //控制充满
                                        child: AnimatedContainer(
                                          duration: widget.animationDuration,
                                          curve: Curves.fastOutSlowIn,
                                          child: headerWidget,
                                        )),
                                    //百分比
                                    Container(
                                        padding: EdgeInsets.only(right: KSize.commonPadding2*2),
                                        child: Text(
                                          '${widget.processCompleteList[index]}%',//'50%',
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                )),
                            //进度
                            Container(
                              color: Colors.transparent,
                              child: CircularProgressWidget(
                                widget.processCompleteList[index],
                                drawerWidth - drawerWidth / 7.0 - KSize.commonPadding2*2,
                                backGroundColor: Color(0xFFF78370),
                                valueProgressColor: progressColor[index],
                              ),
                            ),
                          ]))),
            ],
          ),
        );
      }

      //index主要用于确定进度条颜色
      Widget header = headerWidgetWithIndex(index);

      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        MaterialSlice(
            key: _SaltedKey<BuildContext, int>(context, index * 2),
            child: Container(
              color: Theme.of(context).primaryColor, //Colors.redAccent,
              child: Column(
                children: <Widget>[
                  header,
                  AnimatedCrossFade(
                    //控制折叠
                    firstChild: Container(
//                      color: Colors.blue,
//                      height: 5.0//折叠时控制行与行间隔
                        ),
                    secondChild: child.body,
                    firstCurve:
                        const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                    secondCurve:
                        const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                    sizeCurve: Curves.fastOutSlowIn,
                    crossFadeState: _isChildExpanded(index)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: widget.animationDuration,
                  ),
                ],
              ),
            )),
      );
    }

    return MergeableMaterial(
      hasDividers: widget.hasDividers,
      children: items,
    );
  }
}

class CircularProgressWidget extends StatelessWidget {
  final int progress;
  final double width;
  final double height = 8;
  final double radius = 4;
  final Color backGroundColor;
  final Color valueProgressColor;

  CircularProgressWidget(this.progress, this.width,
      {this.backGroundColor = Colors.red,
      this.valueProgressColor = Colors.amberAccent});

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Stack(
            children: <Widget>[
              Container(
//                width: width,
                height: height,
                decoration: BoxDecoration(color: this.backGroundColor),
              ),
              Positioned(
                left: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  child: Container(
                    width: progress / 100 * width,
                    height: height,
                    decoration: BoxDecoration(color: this.valueProgressColor),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
