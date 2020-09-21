import 'package:flutter/material.dart';
//import 'expand_state_bean.dart';
import 'fold_and_expand_list.dart';
//import 'fold_expand_event_bust.dart';
import 'index_controller.dart';
import 'select_data.dart';

//广播数据
class ProductContentEvent{  // ProductContentEvent 此为自己定义的广播名称。
  String str;
  ProductContentEvent(String str){ this.str=str; }
}
class ZeDieDemo extends StatefulWidget {
  @override
  _ZeDieDemoState createState() => _ZeDieDemoState();
}
class _ZeDieDemoState extends State<ZeDieDemo> {
  IndexController _indexController ;
  final GlobalKey<ZLExpansionPanelListState>key=GlobalKey<ZLExpansionPanelListState>();
  bool value=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexController = IndexController.create(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('fold/expand'),
      ),
      body:Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                child:ZLExpansionPanelList(_indexController,[Text('文科'),Text('理科'),Text('艺术'),Text('兴趣')],
                  [[Text('1'),Text('2')],[Text('3'),Text('4')],[Text('5')],[Text('1'),Text('2'),Text('1'),Text('2')]],[20,40,50,60,70], canTapOnHeader: true, hasDividers:true,headerClickCallback: (index,expand){
                    print('####$index---$expand');
                  },subItemClickCallback: (parentIndex,subIndex){
                    print('******$parentIndex---$subIndex');
                  },key: key,) ,
              ),

              Checkbox(
                value: this.value,
                onChanged: (bool value) {
//                  print('=====$value');
//                  if(value){
//                    print('全选');
//                    key.currentState.selectAll();
//                  }else{
//                    print('取消全选');
//                    key.currentState.loadData();
//                  }
//                  setState(() {
//                  });
//                  this.value=!this.value;
                  //Bus触发事件
//                  eventBus.fire(new ChangeIndexEventBus(3,0));
                  SelectDataModel model=new SelectDataModel(3, 0);
                  _indexController.setSelectedDataModel(model);

                  print('触发');
                },
              ),
            ],
          )
      ),
    );
  }
}
