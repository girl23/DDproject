import 'package:flutter/material.dart';
import 'package:lop/component/xml_table/xml_converted_table.dart';
import 'package:lop/model/jobcard/jc_body_model.dart';
import 'package:lop/model/jobcard/jc_model.dart';
import 'package:lop/model/jobcard/jc_table_model.dart';
import 'package:lop/model/jobcard/job_card_model.dart';
import 'package:lop/model/jobcard/xml_parse.dart';


class XMLTableTestPage extends StatefulWidget {
  @override
  _XMLTableTestPageState createState() => _XMLTableTestPageState();
}

class _XMLTableTestPageState extends State<XMLTableTestPage> {

  TableModel tableModel;

  @override
  void initState() {
    super.initState();
    XMLParse().parseXmlFile('./assets/testxml/protocol_v1_3.xml').then((JobCardModel jcModel){
      ModuleModel model = jcModel.bodyModel.children[0];
      ProcedureModel procedureModel = model.children[0];
      ProItemModel proItemModel = procedureModel.children[2];
      JcLanguageMetaModel mix = proItemModel.mixLanguageModel;
      tableModel = mix.children.last;
      tableModel.tableBodyModel.children.forEach((JcModel model){
      });
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(10),
      child: tableModel == null ? Text('null'):XmlConvertedTable(tableModel, tableWidth:tableModel.width.toDouble(),viewPortWidth: MediaQuery.of(context).size.width - 20,),
    );
  }
}
