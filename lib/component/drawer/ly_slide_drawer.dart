/*
参考: https://github.com/akshathjain/sliding_up_panel/blob/master/LICENSE
*/
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/physics.dart';
enum DrawerState { OPEN, CLOSED }
class LySlideDrawer extends StatefulWidget {
  final Widget Function(ScrollController sc) panelBuilder;
  final Widget body;
  final Widget header;
  final Widget footer;
  final double minWidth;
  final double maxWidth;
  final double headHeight;
  final double footerHeight;
  final double snapPoint;
  final Border border;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;
  final Color color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool renderPanelSheet;
  final bool panelSnapping;
  final PanelController controller;
  final bool backdropEnabled;
  final Color backdropColor;
  final double backdropOpacity;
  final bool backdropTapClosesPanel;
  final void Function(double position) onPanelSlide;
  final VoidCallback onPanelOpened;
  final VoidCallback onPanelClosed;
  final bool parallaxEnabled;
  final double parallaxOffset;
  final bool isDraggable;
  final bool defaultPadding;
  final DrawerState defaultPanelState;

  LySlideDrawer(
      {Key key,
      this.panelBuilder,
      this.body,
      this.headHeight = 0,
      this.footerHeight = 0,
      this.minWidth = 100.0,
      this.maxWidth = 500.0,
      this.snapPoint,
      this.border,
      this.borderRadius,
      this.defaultPadding = false,
      this.boxShadow = const <BoxShadow>[
        BoxShadow(
          blurRadius: 8.0,
          color: Color.fromRGBO(0, 0, 0, 0.25),
        )
      ],
      this.color = Colors.white,
      this.padding,
      this.margin,
      this.renderPanelSheet = true,
      this.panelSnapping = true,
      this.controller,
      this.backdropEnabled = false,
      this.backdropColor = Colors.white,
      this.backdropOpacity = 0.5,
      this.backdropTapClosesPanel = true,
      this.onPanelSlide,
      this.onPanelOpened,
      this.onPanelClosed,
      this.parallaxEnabled = false,
      this.parallaxOffset = 1,
      this.isDraggable = true,
      this.defaultPanelState = DrawerState.CLOSED,
      this.header,
      this.footer})
      : assert(panelBuilder != null),
        assert(0 <= backdropOpacity && backdropOpacity <= 1.0),
        assert(snapPoint == null || 0 < snapPoint && snapPoint < 1.0),
        super(key: key);

  @override
  _LySlideDrawerState createState() => _LySlideDrawerState();
}

class _LySlideDrawerState extends State<LySlideDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _ac;
  ScrollController _sc;
  bool _scrollingEnabled = false;
  VelocityTracker _vt = new VelocityTracker();
  bool _isPanelVisible = true;
  BouncingScrollPhysics _scrollPhysics;

  @override
  void initState() {
    super.initState();
    _ac = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        value: widget.defaultPanelState == DrawerState.CLOSED
            ? 0.0
            : 1.0 //set the default panel state (i.e. set initial value of _ac)
        )
      ..addListener(() {
        if (widget.onPanelSlide != null) widget.onPanelSlide(_ac.value);
        if (widget.onPanelOpened != null && _ac.value == 1.0)
          widget.onPanelOpened();
        if (widget.onPanelClosed != null && _ac.value == 0.0)
          widget.onPanelClosed();
      });
    _sc = new ScrollController();
    _sc.addListener(() {
      if (widget.isDraggable && !_scrollingEnabled) _sc.jumpTo(0);
    });
    widget.controller?._addState(this);
    _scrollPhysics = BouncingScrollPhysics();
//    Future.delayed(Duration(milliseconds: 200)).then((e) {
//      _initSlideMax(widget.slideDirection == SlideDirection.LEFT
//          ? (widget.maxWidth - widget.minWidth)
//          : -(widget.maxWidth - widget.minWidth));
//    });
  }

  @override
  Widget build(BuildContext context) {
    print('slider drawer build');
    return SafeArea(
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          widget.body != null
              ? AnimatedBuilder(
                  animation: _ac,
                  builder: (context, child) {
                    return Positioned(
                      right: widget.parallaxEnabled
                              ? _getParallax()
                              : widget.defaultPadding ? widget.minWidth : 0.0,
                      left: null,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: widget.padding,
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          MediaQueryData.fromWindow(window).padding.top,
                      width: MediaQuery.of(context).size.width,
                      child: widget.body,
                    ),
                  ),
                )
              : Container(),
          !widget.backdropEnabled
              ? Container()
              : GestureDetector(
                  onHorizontalDragEnd: widget.backdropTapClosesPanel
                      ? (DragEndDetails dets) {
                          if (-1 * dets.velocity.pixelsPerSecond.dx > 0) {
                            if (_ac.value == 0.0) {
                              _open();
                            } else {
                              _close();
                            }
                          }
                        }
                      : null,
                  onTap: widget.backdropTapClosesPanel
                      ? () async {
                          if (_ac.value == 0.0) {
                            _open();
                          } else {
                            _close();
                          }
                        }
                      : null,
                  child: AnimatedBuilder(
                      animation: _ac,
                      builder: (context, _) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: _ac.value == 0.0
                              ? null
                              : widget.backdropColor.withOpacity(
                                  widget.backdropOpacity * (_ac.value)),
                        );
                      }),
                ),
          !_isPanelVisible
              ? Container()
              : _gestureHandler(
                  child: AnimatedBuilder(
                    animation: _ac,
                    child: Column(
                      children: <Widget>[
                        // header
                        widget.header ?? Container(),
                        Container(
                          height: MediaQuery.of(context).size.height -
                              widget.headHeight -
                              widget.footerHeight -
                              MediaQueryData.fromWindow(window).padding.top,
                          width: widget.maxWidth,
                          child: widget.panelBuilder(_sc),
                        ),
                        // footer
                        widget.footer ?? Container()
                      ],
                    ),
                    builder: (context, child) {
                      return RepaintBoundary(
                        child: Transform.translate(
                          offset: Offset(_getDx(_ac), 0),
                          child: Container(
                              width: widget.maxWidth,
                              margin: widget.margin,
                              padding: widget.padding,
                              decoration: widget.renderPanelSheet
                                  ? BoxDecoration(
                                      border: widget.border,
                                      borderRadius: widget.borderRadius,
                                      boxShadow: widget.boxShadow,
                                      color: widget.color,
                                    )
                                  : null,
                              child: child),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
  double _getDx(AnimationController ac) {
    return widget.maxWidth - _ac.value * (widget.maxWidth - widget.minWidth);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  double _getParallax() {
    return widget.maxWidth - (-_ac.value + 1) *
              (widget.maxWidth - widget.minWidth) *
              widget.parallaxOffset +
          widget.minWidth;
  }
  Widget _gestureHandler({Widget child}) {
    if (!widget.isDraggable) return child;

    return Listener(
      onPointerDown: (PointerDownEvent p) =>
          _vt.addPosition(p.timeStamp, p.position),
      onPointerMove: (PointerMoveEvent p) {
        _vt.addPosition(p.timeStamp,
            p.position); // add current position for velocity tracking
        _onGestureSlide(p.delta.dx, p.delta.dy);
      },
      onPointerUp: (PointerUpEvent p) => _onGestureEnd(_vt.getVelocity(),p),
      child: child,
    );
  }
  void _initSlideMax(double dx) {
    _ac.value -= dx / (widget.maxWidth - widget.minWidth);
  }
  void _onGestureSlide(double dx, double dy) {
    if (!widget.isDraggable) return;
    if (dx.abs() > dy.abs()) {
      print("dx:$dx");
        if (!_scrollingEnabled) {
          _ac.value -= dx / (widget.maxWidth - widget.minWidth);
        }
      print("_ac.value:${_ac.value}");
        if (_isPanelOpen && _sc.hasClients && _sc.offset <= 0) {
          setState(() {
            if (dx < 0) {
              _scrollingEnabled = true;
            } else {
              _scrollingEnabled = false;
            }
          });
        }
      }

  }
  void _onGestureEnd(Velocity v,PointerUpEvent p) {
    if (!widget.isDraggable) return;
    double minFlingVelocity = 365.0;
    double kSnap = 8;
    if (_ac.isAnimating) return;
    if (_isPanelOpen && _scrollingEnabled) return;
    double visualVelocity =
        -v.pixelsPerSecond.dx / (widget.maxWidth - widget.minWidth);
    visualVelocity = -visualVelocity;
    double d2Close = _ac.value;
    double d2Open = 1 - _ac.value;
    double d2Snap = ((widget.snapPoint ?? 3) - _ac.value).abs();
    double minDistance = min(d2Close, min(d2Snap, d2Open));
    if (v.pixelsPerSecond.dx.abs() >= minFlingVelocity) {
      // snapPoint exists
      if (widget.panelSnapping && widget.snapPoint != null) {
        if (v.pixelsPerSecond.dy.abs() >= kSnap * minFlingVelocity ||
            minDistance == d2Snap)
          _ac.fling(velocity: visualVelocity);
        else
          _flingPanelToPosition(widget.snapPoint, visualVelocity);
      } else if (widget.panelSnapping) {
        _ac.fling(velocity: visualVelocity);
      } else {
        _ac.animateTo(
          _ac.value + visualVelocity * 0.16,
          duration: Duration(milliseconds: 410),
          curve: Curves.decelerate,
        );
      }

      return;
    }
    if (widget.panelSnapping && v.pixelsPerSecond.dx.abs() > 10) {
      if (minDistance == d2Close) {
        _close();
      } else if (minDistance == d2Snap) {
        _flingPanelToPosition(widget.snapPoint, visualVelocity);
      } else {
        _open();
      }
    }
  }

  void _flingPanelToPosition(double targetPos, double velocity) {
    final Simulation simulation = SpringSimulation(
        SpringDescription.withDampingRatio(
          mass: 1.0,
          stiffness: 500.0,
          ratio: 1.0,
        ),
        _ac.value,
        targetPos,
        velocity);
    _ac.animateWith(simulation);
  }
  Future<void> _close() {
    return _ac.fling(velocity: -1.0);
  }
  Future<void> _open() {
    return _ac.fling(velocity: 1.0);
  }
  Future<void> _hide() {
    _isPanelVisible = false;
    return _ac.fling(velocity: -1.0).then((x) {
//      setState(() {
//        _isPanelVisible = false;
//      });
    });
  }
  Future<void> _show() {
    _isPanelVisible = true;
    return _ac.fling(velocity: 1.0).then((x) {
//      setState(() {
//        _isPanelVisible = true;
//      });
    });
  }
  Future<void> _animatePanelToPosition(double value,
      {Duration duration, Curve curve = Curves.linear}) {
    assert(0.0 <= value && value <= 1.0);
    return _ac.animateTo(value, duration: duration, curve: curve);
  }
  Future<void> _animatePanelToSnapPoint(
      {Duration duration, Curve curve = Curves.linear}) {
    assert(widget.snapPoint != null);
    return _ac.animateTo(widget.snapPoint, duration: duration, curve: curve);
  }
  set _panelPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _ac.value = value;
  }
  double get _panelPosition => _ac.value;
  bool get _isPanelAnimating => _ac.isAnimating;
  bool get _isPanelOpen => _ac.value == 1.0;
  bool get _isPanelClosed => _ac.value == 0.0;
  bool get _isPanelShown => _isPanelVisible;
}
class PanelController {
  _LySlideDrawerState _panelState;

  void _addState(_LySlideDrawerState panelState) {
    this._panelState = panelState;
  }
  bool get isAttached => _panelState != null;
  Future<void> close() {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._close();
  }
  Future<void> open() {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._open();
  }
  Future<void> hide() {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._hide();
  }
  Future<void> show() {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._show();
  }
  Future<void> animatePanelToPosition(double value,
      {Duration duration, Curve curve = Curves.linear}) {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    assert(0.0 <= value && value <= 1.0);
    return _panelState._animatePanelToPosition(value,
        duration: duration, curve: curve);
  }
  Future<void> animatePanelToSnapPoint(
      {Duration duration, Curve curve = Curves.linear}) {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    assert(_panelState.widget.snapPoint != null,
        "SlidingUpPanel snapPoint property must not be null");
    return _panelState._animatePanelToSnapPoint(
        duration: duration, curve: curve);
  }
  set panelPosition(double value) {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    assert(0.0 <= value && value <= 1.0);
    _panelState._panelPosition = value;
  }
  double get panelPosition {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._panelPosition;
  }
  bool get isPanelAnimating {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._isPanelAnimating;
  }
  bool get isPanelOpen {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._isPanelOpen;
  }
  bool get isPanelClosed {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._isPanelClosed;
  }
  bool get isPanelShown {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState._isPanelShown;
  }
  double get acValue{
    return _panelState._ac.value;
  }
}
