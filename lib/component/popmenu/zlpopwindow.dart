///使用dropMenuButton的思想创建弹框，自定义window
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton({
    Key key,
    this.child,
    this.window,
    this.offset = Offset.zero,
    this.elevation = 2.0,
    this.duration = 300,
    this.type = MaterialType.card,
    this.color,
  }) : super(key: key);

  /// 显示按钮button
  /// button which clicked will popup a window
  final Widget child;

  /// window 出现的位置。左上角的位置
  /// window's position in screen
  final Offset offset;

  /// 阴影
  /// shadow
  final double elevation;

  /// 需要显示的window
  /// the target window
  final Widget window;

  /// 按钮按钮后到显示window 出现的时间
  /// the transition duration before [window] show up
  final int duration;

  final MaterialType type;
  final Color color;

  @override
  _PopupWindowButtonState createState() {
    return _PopupWindowButtonState();
  }
}

void showWindow<T>({
  @required BuildContext context,
  RelativeRect position,
  @required Widget window,
  double elevation = 8.0,
  int duration = _windowPopupDuration,
  String semanticLabel,
  MaterialType type,
  Color color,
}) {
  Navigator.push(
    context,
    _PopupWindowRoute<T>(
        position: position,
        child: window,
        elevation: elevation,
        duration: duration,
        semanticLabel: semanticLabel,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        type: type,
        color: color,
    ),
  );
}

class _PopupWindowButtonState<T> extends State<PopupWindowButton> {
  void _showWindow() {
    //控制dropmenubutton背景为透明
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    // 通过findRenderObject获取PopupMenuButton的尺寸(button.size)
    final RenderBox button = context.findRenderObject();
    //Overlay 是个什么东西呢？
    //看下介绍 A [Stack] of entries that can be managed independently
    // 一个Stack  可以管理独立的entries。
    // 接着看Overlay.of(context)
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    // 一个相对的2D矩形 尺寸相对于父容器
    // fromReact肯定是创建矩形，怎么创建？由一个父矩形 和 自己，
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
//      使用左上和右下角坐标来确定矩形的大小和位置
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showWindow<T>(
        context: context,
        window: widget.window,
        position: position,
        duration: widget.duration,
        elevation: widget.elevation,
        type: widget.type,
        color:widget.color ?? popupMenuTheme.color,
    );

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showWindow,
      child: widget.child,//子视图
    );
  }
}

class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute({
    this.position,
    this.child,
    this.elevation,
    this.theme,
    this.barrierLabel,
    this.semanticLabel,
    this.duration,
    this.type = MaterialType.card,
    this.color,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  final RelativeRect position;
  final Widget child;
  final double elevation;
  final ThemeData theme;
  final String semanticLabel;
  @override
  final String barrierLabel;
  final int duration;
  final MaterialType type;
  final Color color;

  @override
  Duration get transitionDuration =>
      duration == 0 ? _kWindowDuration : Duration(milliseconds: duration);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Builder(
      builder: (BuildContext context) {
        final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
        return CustomSingleChildLayout(
          delegate: _PopupWindowLayout(position),
          child:
          AnimatedBuilder(
              child: child,
              animation: animation,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: Material(
                    color: color ?? popupMenuTheme.color,
                    type: type,
                    elevation: elevation,
                    child: child,
                  ),
                );
              }),
        );
      },
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}
