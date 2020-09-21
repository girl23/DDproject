import 'package:flutter/cupertino.dart';
import 'select_data.dart';

abstract class IndexController {
  factory IndexController.create(State state) => IndexControllerImp(state);

  State get state;

  void setSelectedDataModel(SelectDataModel model);

   SelectDataModel get selectDataModel;

   ValueNotifier<List<SelectDataModel>> get indexPosition;
}

class IndexControllerImp implements IndexController {
  State _state;

  @override
  final ValueNotifier<List<SelectDataModel>> indexPosition = ValueNotifier([new SelectDataModel(0, 0),new SelectDataModel(0, 0)]);
  IndexControllerImp(State state)
      : _state = state,
        super();

  SelectDataModel _selectDataModel;
  @override
  void setSelectedDataModel(SelectDataModel model) {
    // TODO: implement setSelectedIndex

    SelectDataModel oldSelectedModel=_selectDataModel;
    if(oldSelectedModel==null){
      _selectDataModel=model;
      indexPosition.value=[_selectDataModel,_selectDataModel];
      print('objectold${model.selectedHeaderIndex}=====${model.selectedSubIndex}');
    }else{
      SelectDataModel newSelectedModel=model;
      if(newSelectedModel!=oldSelectedModel){
        _selectDataModel=newSelectedModel;
        indexPosition.value=[oldSelectedModel,newSelectedModel];
        print('objectnew${model.selectedHeaderIndex}=====${model.selectedSubIndex}');
      }
    }
  }
  @override
  // TODO: implement state
  State<StatefulWidget> get state => _state;
  @override
  SelectDataModel get selectDataModel =>_selectDataModel;


}

