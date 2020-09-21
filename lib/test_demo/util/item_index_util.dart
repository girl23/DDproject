class ItemIndexUtls{
  static Map<int,Map<int,Map<int,List<List<int>>>>> _indexMap = Map();

  static void pushInex(int itemId,int dataIndex,int index,int startIndex,int endIndex){
    List<List<int>> indexs = _indexMap[itemId][dataIndex][index]??[];
    indexs.add([startIndex,endIndex]);
    _indexMap[itemId][dataIndex][index] = indexs;
  }

  static List<List<int>> getIndex(int itemId,int dataIndex,int index){
    return _indexMap[itemId][dataIndex][index]??[];
  }
}