class DDListModel {
  int total;
  List<DDListItemModel> data;
  int page;
  int pageCount;
  String listKey;

  DDListModel(
      {
        this.total,
        this.data,
        this.page,
        this.pageCount,
        this.listKey});

  DDListModel.fromJson(Map<String, dynamic> json) {

    total = json['total'];
    if (json['data'] != null) {
      data = new List<DDListItemModel>();
      json['data'].forEach((v) {
        data.add(new DDListItemModel.fromJson(v));
      });
    }
    page = json['page'];
    pageCount = json['pageCount'];
    listKey = json['listKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['pageCount'] = this.pageCount;
    data['listKey'] = this.listKey;
    return data;
  }
}

class DDListItemModel {
  String zzmel3;
  String zzgzms;
  String zzmel2;
  String zzmsgrp;
  String zzrecType;
  String zzmel;
  String zzmel5;
  int ddid;
  String zzmel4;
  String ddReport;
  String zzbltel;
  String zzrescode;
  String zzytsj;
  String zzsxgs;
  String zzblfax;
  String zzblclf;
  int zzbgdt;
  String zzblno;
  String zzblry;
  String zzbltyp;
  String zzotext;
  String falqty;
  String zzflgoth;
  String zzatazj2;
  int zzblfxxh;
  int zzblfxxs;
  String zzflgo;
  int zzdefdy;
  String instqty;
  String zzatazj;
  String zzmind;
  String zzyxfwcd;
  String zzamcfg;
  String toolName;
  int createTime;
  String partNo;
  int creater;
  String zzddscbgdd;
  String ddState;

  DDListItemModel(
      {this.zzmel3,
        this.zzgzms,
        this.zzmel2,
        this.zzmsgrp,
        this.zzrecType,
        this.zzmel,
        this.zzmel5,
        this.ddid,
        this.zzmel4,
        this.ddReport,
        this.zzbltel,
        this.zzrescode,
        this.zzytsj,
        this.zzsxgs,
        this.zzblfax,
        this.zzblclf,
        this.zzbgdt,
        this.zzblno,
        this.zzblry,
        this.zzbltyp,
        this.zzotext,
        this.falqty,
        this.zzflgoth,
        this.zzatazj2,
        this.zzblfxxh,
        this.zzblfxxs,
        this.zzflgo,
        this.zzdefdy,
        this.instqty,
        this.zzatazj,
        this.zzmind,
        this.zzyxfwcd,
        this.zzamcfg,
        this.toolName,
        this.createTime,
        this.partNo,
        this.creater,
        this.zzddscbgdd,
        this.ddState,
      });
  DDListItemModel.fromJson(Map<String, dynamic> json) {
    zzmel3 = json['zzmel3'];
    zzgzms = json['zzgzms'];
    zzmel2 = json['zzmel2'];
    zzmsgrp = json['zzmsgrp'];
    zzrecType = json['zzrecType'];
    zzmel = json['zzmel'];
    zzmel5 = json['zzmel5'];
    ddid = json['ddid'];
    zzmel4 = json['zzmel4'];
    ddReport = json['ddReport'];
    zzbltel = json['zzbltel'];
    zzrescode = json['zzrescode'];
    zzytsj = json['zzytsj'];
    zzsxgs = json['zzsxgs'];
    zzblfax = json['zzblfax'];
    zzblclf = json['zzblclf'];
    zzbgdt = json['zzbgdt'];
    zzblno = json['zzblno'];
    zzblry = json['zzblry'];
    zzbltyp = json['zzbltyp'];
    zzotext = json['zzotext'];
    falqty = json['falqty'];
    zzflgoth = json['zzflgoth'];
    zzatazj2 = json['zzatazj2'];
    zzblfxxh = json['zzblfxxh'];
    zzblfxxs = json['zzblfxxs'];
    zzflgo = json['zzflgo'];
    zzdefdy = json['zzdefdy'];
    instqty = json['instqty'];
    zzatazj = json['zzatazj'];
    zzmind = json['zzmind'];
    zzyxfwcd = json['zzyxfwcd'];
    zzamcfg = json['zzamcfg'];
    toolName = json['toolName'];
    createTime = json['createTime'];
    partNo = json['partNo'];
    creater = json['creater'];
    zzddscbgdd = json['zzddscbgdd'];
    ddState = json['ddState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zzmel3'] = this.zzmel3;
    data['zzgzms'] = this.zzgzms;
    data['zzmel2'] = this.zzmel2;
    data['zzmsgrp'] = this.zzmsgrp;
    data['zzrecType'] = this.zzrecType;
    data['zzmel'] = this.zzmel;
    data['zzmel5'] = this.zzmel5;
    data['ddid'] = this.ddid;
    data['zzmel4'] = this.zzmel4;
    data['ddReport'] = this.ddReport;
    data['zzbltel'] = this.zzbltel;
    data['zzrescode'] = this.zzrescode;
    data['zzytsj'] = this.zzytsj;
    data['zzsxgs'] = this.zzsxgs;
    data['zzblfax'] = this.zzblfax;
    data['zzblclf'] = this.zzblclf;
    data['zzbgdt'] = this.zzbgdt;
    data['zzblno'] = this.zzblno;
    data['zzblry'] = this.zzblry;
    data['zzbltyp'] = this.zzbltyp;
    data['zzotext'] = this.zzotext;
    data['falqty'] = this.falqty;
    data['zzflgoth'] = this.zzflgoth;
    data['zzatazj2'] = this.zzatazj2;
    data['zzblfxxh'] = this.zzblfxxh;
    data['zzblfxxs'] = this.zzblfxxs;
    data['zzflgo'] = this.zzflgo;
    data['zzdefdy'] = this.zzdefdy;
    data['instqty'] = this.instqty;
    data['zzatazj'] = this.zzatazj;
    data['zzmind'] = this.zzmind;
    data['zzyxfwcd'] = this.zzyxfwcd;
    data['zzamcfg'] = this.zzamcfg;
    data['toolName'] = this.toolName;
    data['createTime'] = this.createTime;
    data['partNo'] = this.partNo;
    data['creater'] = this.creater;
    data['zzddscbgdd'] = this.zzddscbgdd;
    data['ddState']=this.ddState ;
    return data;
  }
}
