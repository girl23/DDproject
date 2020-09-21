import 'package:flutter/material.dart';
import '../../model/jc_sign_model.dart';
import 'package:provider/provider.dart';

class LyChangeTextSizeSlide extends StatefulWidget {
  @override
  _LyChangeTextSizeSlideState createState() => _LyChangeTextSizeSlideState();
}

class _LyChangeTextSizeSlideState extends State<LyChangeTextSizeSlide> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JcSignModel>(builder: (context, provider, child) {
      return Listener(
          onPointerDown: (PointerDownEvent p) {
            provider.drawerisDragable = false;
          },
          onPointerMove: (PointerMoveEvent p) {
            provider.drawerisDragable = false;
          },
          onPointerUp: (PointerUpEvent p) {
            provider.drawerisDragable = true;
          },
          child: Row(
            children: <Widget>[
              Text("1"),
              SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: Slider(
                    min: 1.0,
                    max: 4.0,
                    value: provider.fontScale,
                    onChanged: (value) {
//                      Future.delayed(Duration(milliseconds: 400)).then((_){
                        provider.fontScale = value;
//                      });

                    },
                    divisions: 60,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.black26,
                  )),
              Text("4"),
            ],
          ));
    });
  }
}
