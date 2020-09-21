class MaterialCaModel {
  String matnr; //件号
  String maktx; //件号描述
  String werks; //基地
  String lgort; //库存地
  String charg; //批次
  String lifnr; //供应商
  String name1; //供应商描述
  String kunnr; //客户
  String name2; //客户描述
  String sobkz; //特殊库存标记
  String gernr; //序号
  String cinsm; //质检数量
  String clabs; //数量
  String bdmng; //预留数量
  String cumlm; //是否在途
  String partStatus; //件状
  String zSys; //适用性
  String sled; //过期日

  //hana新接口返回字段
  String material_no;	//件号
  String material_desc_cn;	//件号描述
  String plant;	//基地
  String location;	//库存地
  String batch_no;	//批次
  String vendor;	//供应商
  //供应商描述
  String customer;	//客户
  //客户描述
  String special_stock;	//特殊库存标记
  String serial_no;	//序号
  String qty_inspection;	//质检数量
  String qty_stock;	//数量
  String qty_reservation;	//预留数量
  String transporting;	//是否在途
  String status;	//件状
  String applicability;	//适用性
  String expiration_date;	//过期日

  MaterialCaModel.fromJson(Map<String, dynamic> json) {
    matnr = json['matnr'];
    maktx = json['maktx'];
    werks = json['werks'];
    lgort = json['lgort'];
    charg = json['charg'];
    lifnr = json['lifnr'];
    name1 = json['name1'];
    kunnr = json['kunnr'];
    name2 = json['name2'];
    sobkz = json['sobkz'];
    gernr = json['gernr'];
    cinsm = json['cinsm'];
    clabs = json['clabs'];
    bdmng = json['bdmng'];
    cumlm = json['cumlm'];
    partStatus = json['part_status'];
    zSys = json['z_sys'];
    sled = json['sled'];

    //hana新接口字段
    material_no = json['material_no'];	//件号
    material_desc_cn = json['material_desc_cn'];	//件号描述
    plant = json['plant'];	//基地
    location = json['location'];	//库存地
    batch_no = json['batch_no'];	//批次
    vendor = json['vendor'];	//供应商
    //供应商描述
    customer = json['customer'];	//客户
    //客户描述
    special_stock = json['special_stock'];	//特殊库存标记
    serial_no = json['serial_no'];	//序号
    qty_inspection = json['qty_inspection'];	//质检数量
    qty_stock = json['qty_stock'];	//数量
    qty_reservation = json['qty_reservation'];	//预留数量
    transporting = json['transporting'];	//是否在途
    status = json['status'];	//件状
    applicability = json['applicability'];	//适用性
    expiration_date = json['expiration_date'];	//过期日
  }
}
