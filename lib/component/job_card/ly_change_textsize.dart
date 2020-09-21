import 'package:flutter/material.dart';
import '../../model/jc_sign_model.dart';
//import '../../provider/sign_item_provider.dart';
import '../slider/radio/radio_slider.dart';
import 'package:provider/provider.dart';

class LyChangeTextSize extends StatefulWidget {
  @override
  _LyChangeTextSizeState createState() => _LyChangeTextSizeState();
}

class _LyChangeTextSizeState extends State<LyChangeTextSize> {
  @override
  Widget build(BuildContext context) {
    return
      Consumer<JcSignModel>(builder: (context, provider, child) {
      return Column(
        children: <Widget>[
          Text("字体大小：${provider.fontScale}"),
          Row(
            children: <Widget>[
              Text("1"),
              SliderTheme(
                data: SliderThemeData(
                    trackHeight: 3,
                    activeTickMarkColor: Colors.lightGreen,
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.blue,
                    inactiveTickMarkColor: Colors.blue
                ),
                child: RadioSlider(
                  onChanged: (value) {
//                    Future.delayed(Duration(milliseconds: 200)).then((_){
                      provider.fontScale = value;
//                    });
                  },
                  min: 1.0,
                  max: 4.0,
                  thumbWidth: 8.0,
                  thumbOutWidth: 8.0,
                  tickMarkWidth: 8.0,
                  tickMarkOutWidth: 10.0,
                  value: provider.fontScale,
                  divisions: 3,
                  outerCircle: false,
                ),
              ),
              Text("4"),
            ],
          )
        ],
      );
    });
  }
}
