import 'package:lop/component/sectionlist/item_position.dart';

class TaskItemPosition extends ItemPosition{
  int moduleIndex;
  TaskItemPosition({
    this.moduleIndex,
    int index,
    int section,
    int row,
    double itemHeight
}):super(index:index,section:section,row:row,itemHeight:itemHeight);

  @override
  String toString() {
    return '${super.toString()} moduleIndex: $moduleIndex';
  }


}