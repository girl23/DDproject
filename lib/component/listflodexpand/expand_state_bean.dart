//list中item状态自定义类
class ExpandStateBean{
  bool isOpen;   //item是否打开
  int index;    //item中的索引
  ExpandStateBean(this.index,this.isOpen,);
}

class ModuleSelectStateBean{
  bool isSelect;   //item是否选中
  int index;    //item中的索引
  int procedureCount = 0;
  ModuleSelectStateBean(this.index,this.isSelect,this.procedureCount);

  @override
  String toString() {
    return 'ModuleSelectStateBean{isSelect: $isSelect, index: $index, procedureCount: $procedureCount}';
  }

}