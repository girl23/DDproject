import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data_model/table_model.dart';
import '../../component/xml_table/xml_converted_table.dart';
import 'xml_table/xml_util.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TableModel _tableModel;
  List<TableModel> _tableModels = [];

  void _incrementCounter() {
//    setState(() {
//
//    });
//    readXml();
  Navigator.push(context, PageRouteBuilder(pageBuilder: (context,a1,a2){
    return NewPage();
  }));
  }

  @override
  void initState() {
    readXml();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
//      body: ListView.builder(
////        child: IndentCustomCheckBoxWidget(children: [IndentCheckBoxItem('hahahahahahaha'), IndentCheckBoxItem('hohohohohohoh')]),
//        itemCount: 3,
//        itemBuilder: (context,index){
//          return _tableModels.length == 0 ? Text('null') : XmlConvertedTable(_tableModels[0],MediaQuery.of(context).size.width,padding: EdgeInsets.all(3),);
//        },
//      ),
      body: Container(
        color: Colors.grey[300],
//        child: IndentCustomCheckBoxWidget(children: [IndentCheckBoxItem('hahahahahahaha'), IndentCheckBoxItem('hohohohohohoh')]),
        child: ListView.builder(
          itemBuilder: (context, index){
            if(index < 3){
              return Text('SDK父控件时倒海翻江第四爱而房价都是风景红烧豆腐几乎都是空间发货的数据库是的咖啡机SDK 水电费不合适的机会多喝点水的咖啡机SDK 水电费不合适的机会多喝点水', style: TextStyle(fontSize: 20),);
            }else if(index >= 3 && index < 4){
//              return _tableModels.length == 0 ? Text('null') : XmlConvertedTable(_tableModels[0],500,padding: EdgeInsets.all(10),);
            }else if(index >= 4 && index < 6){
              return Text('看啥就大富豪决定是否合适空间发挥空间的十分思考发货时间客户看啥就大富豪决定是否合适空间发挥空间的十分思考发货时间客户', style: TextStyle(fontSize: 20),);
            }else{
//              return _tableModels.length == 0 ? Text('null') : XmlConvertedTable(_tableModels[0],MediaQuery.of(context).size.width,padding: EdgeInsets.all(10),);
            }
          },
          itemCount: 10,
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void readXml() async{

    XmlParseUtil().parseXmlFile("assets/xml/xml1.xml").then((data){
      data.forEach((model){
        if(model.runtimeType == TableModel){
          _tableModels.add(model);
        }
      });
      _tableModel = _tableModels[0];
    });

    print('${getNum().toList()}');
    getNumAsync().toList().then((value){
      print('value: $value');
    });
  }

  Iterable<int> getNum() sync*{
    print('get num');
    for(int i = 0; i < 3; i++){
      print('当前index：$i');
      yield i;
    }
  }

  Stream<int> getNumAsync() async*{
    print('get number async');
    for(int i = 0; i < 3; i++){
      print('当前index：$i');
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('new page'),),
      body: Container(),
    );
  }
}
