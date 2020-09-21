
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';

typedef DeleteFilter = void Function(String title);

class FilterItemCollector extends StatefulWidget {

  final List<String> filterTitles;
  final DeleteFilter onDelete;
  final double itemHeight;
  final double itemWidth;

  void _updateItemTitle(String itemTitle){
    filterTitles.add(itemTitle);
  }

  void updateItemTitles(List<String> titles){
    filterTitles.clear();
    filterTitles.addAll(titles);
  }

  FilterItemCollector(this.filterTitles, {this.onDelete, this.itemHeight = 50, this.itemWidth = 80});

  @override
  _FilterItemCollectorState createState() => _FilterItemCollectorState();
}

class _FilterItemCollectorState extends State<FilterItemCollector> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: true,
      child: Container(
        margin: EdgeInsets.all(KSize.commonMargin2),
        width: ScreenUtil.screenWidth,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: ScreenUtil().setWidth(KSize.commonMargin2),
          runSpacing: ScreenUtil().setWidth(KSize.commonMargin1),
          children: widget.filterTitles.map((str){
            return Container(
              margin: EdgeInsets.only(right: KSize.commonMargin2),
              padding: EdgeInsets.all(KSize.commonPadding2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:BorderRadius.circular(ScreenUtil().setSp(20)),
                border: Border.all(
                  color: Colors.grey
                )
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(str, style: TextStyle(fontSize: KFont.fontSizeCommon_2),),
                  SizedBox(width: KSize.commonPadding1,),
                  GestureDetector(
                    child: Icon(Icons.cancel),
                    onTap: (){
                      if(widget.onDelete != null){
                        widget.onDelete(str);
                      }
                    },
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
