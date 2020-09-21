import 'jc_model.dart';

///
/// 工卡的附图节点<figure/>
///
class FigureModel extends JcListModel {
  String tag = 'figure';
  String rawData;
  @override
  String toString() {
    if(rawData != null){
      return rawData;
    }
    return '<figure>' + super.toString() + '</figure>';
  }
}
