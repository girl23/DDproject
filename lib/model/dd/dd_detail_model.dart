import 'package:lop/utils/date_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/config/global.dart';
import 'package:flutter/material.dart';
class DDDetailModel {
  static  BuildContext appContext =Global.navigatorKey.currentContext;
  String zzotext;
  String zzfjzfxxs;
  String zzrescode;
  String zzifrchk;
  String creater;
  String zztzxndt;
  String zzusbintervd;
  String zzbltyp;
  String zzcldate;
  String zzblno;
  String aedat;
  String sernr;
  String maintenanceunit;
  String zzlbd;
  String aenam;
  String zzscz;
  String erdat;
  String zzatazj2;
  String ddreport;
  String zzremark;
  String zzrectype;
  String zzftype;
  String ddid;
  String zzblclf;
  String zzdate4;
  String changetime;
  String zzdefdy;
  String zzdate2;
  String zztoamc;
  String zzfasys;
  String zzdate3;
  String zzyxfwcd;
  String zzytsj;
  String zzdate1;
  String zzmsgrp;
  String entrytype;
  String zzddplanner;
  String zziftzpz;
  String zzcjqmnum;
  String closetime;
  String zzzzhwj;
  String zzblfxxs;
  String zzatazj;
  String zzpcdat;
  String zzmind;
  String zztzpzdt;
  String zzcomfirmbz;
  String zzblfxxh;
  String zzzgjdfax;
  String inspectionby;
  String approveddate;
  String zzsbintervd;
  String relqty;
  String partno;
  String zzflgo;
  String zzsffris;
  String zztzqpdt;
  String deletetime;
  String zzbgdt;
  String zzsrcobj;
  String zzfiblzfc;
  String zztzlgdt;
  String zzflgoth;
  String zzaenam;
  String zztimes;
  String zzgzms;
  String zzrefblno;
  String zzsxgs;
  String zzmel3;
  String zzmel2;
  String mandt;
  String zzfstnm;
  String zzblfax;
  String deleter;
  String zzrepeatind;
  String zzblry;
  String falqty;
  String zzstart;
  String zzandor;
  String zzblst;
  String zzmel;
  String closeby;
  String zzbltel;
  String zziftzqp;
  String ernam;
  String instqty;
  String zztatzj3;
  String zzmel4;
  String zzfjblzfh;
  String zzmel5;
  String maintenanceby;
  String zzamcfg;
  String zzcluser;
  String qmnum;
  String zzzgjdtel;
  String zzxnsend;
  String zzfizfxxh;
  String zzbluser;
  String zzwo;
  String createtime;
  String zzifxn;
  String processingresult;
  String zzddscbgdd;
  String approvedby;
  String ztosocinfo;
  String zzuser4;
  String zzuser3;
  String zzuser2;
  String zzuser1;
  String zzmbno;
  String zzzzsqx;
  String toolname;
  String zznottoamc;
  String zloekz;
  String zzifyl;
  String ddstate;
  String zznstrint;
  String rsnum;
  String zzfxdt;
  String zziftzlg;
  String zzsecdpg;
  String changer;
  String operatinglimits;
  String applyby;
  String applydate;
  String performanceresult;
  DDDetailModel(
      {this.zzotext,
        this.zzfjzfxxs,
        this.zzrescode,
        this.zzifrchk,
        this.creater,
        this.zztzxndt,
        this.zzusbintervd,
        this.zzbltyp,
        this.zzcldate,
        this.zzblno,
        this.aedat,
        this.sernr,
        this.maintenanceunit,
        this.zzlbd,
        this.aenam,
        this.zzscz,
        this.erdat,
        this.zzatazj2,
        this.ddreport,
        this.zzremark,
        this.zzrectype,
        this.zzftype,
        this.ddid,
        this.zzblclf,
        this.zzdate4,
        this.changetime,
        this.zzdefdy,
        this.zzdate2,
        this.zztoamc,
        this.zzfasys,
        this.zzdate3,
        this.zzyxfwcd,
        this.zzytsj,
        this.zzdate1,
        this.zzmsgrp,
        this.entrytype,
        this.zzddplanner,
        this.zziftzpz,
        this.zzcjqmnum,
        this.closetime,
        this.zzzzhwj,
        this.zzblfxxs,
        this.zzatazj,
        this.zzpcdat,
        this.zzmind,
        this.zztzpzdt,
        this.zzcomfirmbz,
        this.zzblfxxh,
        this.zzzgjdfax,
        this.inspectionby,
        this.approveddate,
        this.zzsbintervd,
        this.relqty,
        this.partno,
        this.zzflgo,
        this.zzsffris,
        this.zztzqpdt,
        this.deletetime,
        this.zzbgdt,
        this.zzsrcobj,
        this.zzfiblzfc,
        this.zztzlgdt,
        this.zzflgoth,
        this.zzaenam,
        this.zztimes,
        this.zzgzms,
        this.zzrefblno,
        this.zzsxgs,
        this.zzmel3,
        this.zzmel2,
        this.mandt,
        this.zzfstnm,
        this.zzblfax,
        this.deleter,
        this.zzrepeatind,
        this.zzblry,
        this.falqty,
        this.zzstart,
        this.zzandor,
        this.zzblst,
        this.zzmel,
        this.closeby,
        this.zzbltel,
        this.zziftzqp,
        this.ernam,
        this.instqty,
        this.zztatzj3,
        this.zzmel4,
        this.zzfjblzfh,
        this.zzmel5,
        this.maintenanceby,
        this.zzamcfg,
        this.zzcluser,
        this.qmnum,
        this.zzzgjdtel,
        this.zzxnsend,
        this.zzfizfxxh,
        this.zzbluser,
        this.zzwo,
        this.createtime,
        this.zzifxn,
        this.processingresult,
        this.zzddscbgdd,
        this.approvedby,
        this.ztosocinfo,
        this.zzuser4,
        this.zzuser3,
        this.zzuser2,
        this.zzuser1,
        this.zzmbno,
        this.zzzzsqx,
        this.toolname,
        this.zznottoamc,
        this.zloekz,
        this.zzifyl,
        this.ddstate,
        this.zznstrint,
        this.rsnum,
        this.zzfxdt,
        this.zziftzlg,
        this.zzsecdpg,
        this.changer,
        this.operatinglimits,
        this.applyby,
        this.applydate,
        this.performanceresult,
      });

  DDDetailModel.fromJson(Map<String, dynamic> json) {
    zzotext = json['zzotext'];
    zzfjzfxxs = json['zzfjzfxxs'];
    zzrescode = json['zzrescode'];
    zzifrchk = json['zzifrchk'];
    creater = json['creater'];
    zztzxndt = json['zztzxndt'];
    zzusbintervd = json['zzusbintervd'];
    zzbltyp = json['zzbltyp'];
    String tempStr4=json['zzcldate'];
    DateTime tempDate4=DateTime.parse(tempStr4.length>0?tempStr4:'1979-01-01');
    zzcldate =DateUtil.formateYMD(tempDate4);
    zzblno = json['zzblno'];
    aedat = json['aedat'];
    sernr = json['sernr'];
    //维修单位
    String mbCode;
    if(json['maintenanceunit']=='1'){
      mbCode=Translations.of(appContext).text('dd_MB1');
    }else if(json['maintenanceunit']=='2'){
      mbCode=Translations.of(appContext).text('dd_MB2');
    }else if(json['maintenanceunit']=='3'){
      mbCode=Translations.of(appContext).text('dd_MB3');
    }else if(json['maintenanceunit']=='4'){
      mbCode=Translations.of(appContext).text('dd_MB4');
    }else if(json['maintenanceunit']=='5'){
      mbCode=Translations.of(appContext).text('dd_MB5');
    }else if(json['maintenanceunit']=='6'){
      mbCode=Translations.of(appContext).text('dd_MB6');
    }else if(json['maintenanceunit']=='7'){
      mbCode=Translations.of(appContext).text('dd_MB7');
    }else if(json['maintenanceunit']=='8'){
      mbCode=Translations.of(appContext).text('dd_MB8');
    }else if(json['maintenanceunit']=='9'){
      mbCode=Translations.of(appContext).text('dd_MB9');
    }else if(json['maintenanceunit']=='10'){
      mbCode=Translations.of(appContext).text('dd_MB10');
    }
    maintenanceunit = mbCode;//json['maintenanceunit'];
    zzlbd = json['zzlbd'];
    aenam = json['aenam'];
    zzscz = json['zzscz'];
    erdat = json['erdat'];
    zzatazj2 = json['zzatazj2'];
    ddreport = json['ddreport'];
    zzremark = json['zzremark'];
    //依据类型
    String tempStr8;
    if(json['zzrectype']=='0'){
      tempStr8="MEL";
    }else if(json['zzrectype']=='1'){
      tempStr8="CDL";
    }else if(json['zzrectype']=='2'){
      tempStr8="其它";
    }
    zzrectype = tempStr8;//json['zzrectype'];
    zzftype = json['zzftype'];
    ddid = json['ddid'];
    zzblclf = json['zzblclf'];
    zzdate4 = json['zzdate4'];
    changetime = json['changetime'];
    zzdefdy = json['zzdefdy'];
    zzdate2 = json['zzdate2'];
    zztoamc = json['zztoamc'];
    zzfasys = json['zzfasys'];
    zzdate3 = json['zzdate3'];
    //影响服务程度
    String influence;
    if(json['zzyxfwcd']=='0'){
      influence=Translations.of(appContext).text('dd_influence_level1');
    }else if(json['zzyxfwcd']=='1'){
      influence=Translations.of(appContext).text('dd_influence_level2');
    }else if(json['zzyxfwcd']=='2'){
      influence=Translations.of(appContext).text('dd_influence_level3');
    }
    zzyxfwcd = influence;//json['zzyxfwcd'];
    zzytsj = json['zzytsj'];
    zzdate1 = json['zzdate1'];
    zzmsgrp = json['zzmsgrp'];
    entrytype = json['entrytype'];
    zzddplanner = json['zzddplanner'];
    zziftzpz = json['zziftzpz'];
    zzcjqmnum = json['zzcjqmnum'];
    closetime = json['closetime'];
    zzzzhwj = json['zzzzhwj'];
    zzblfxxs = json['zzblfxxs'];
    zzatazj = json['zzatazj'];
    zzpcdat = json['zzpcdat'];
    zzmind = json['zzmind'];
    zztzpzdt = json['zztzpzdt'];
    zzcomfirmbz = json['zzcomfirmbz'];
    zzblfxxh = json['zzblfxxh'];
    zzzgjdfax = json['zzzgjdfax'];
    inspectionby = json['inspectionby'];
    //批准日期
    String tempStr6=json['approveddate'];
    DateTime tempDate6=DateTime.parse(tempStr6.length>0?tempStr6:'1979-01-01');//DateTime.parse(json['zzbgdt']);
    approveddate =DateUtil.formateYMD(tempDate6);
    zzsbintervd = json['zzsbintervd'];
    relqty = json['relqty'];
    partno = json['partno'];
    zzflgo = json['zzflgo'];
    zzsffris = json['zzsffris'];
    zztzqpdt = json['zztzqpdt'];
    deletetime = json['deletetime'];
    //报告日期
    String tempStr1=json['zzbgdt'];
    DateTime tempDate1=DateTime.parse(tempStr1.length>0?tempStr1:'1979-01-01');//DateTime.parse(json['zzbgdt']);
    zzbgdt = DateUtil.formateYMD(tempDate1);
    zzsrcobj = json['zzsrcobj'];
    zzfiblzfc = json['zzfiblzfc'];
    zztzlgdt = json['zztzlgdt'];
    zzflgoth = json['zzflgoth'];
    zzaenam = json['zzaenam'];
    zztimes = json['zztimes'];
    zzgzms = json['zzgzms'];
    zzrefblno = json['zzrefblno'];
    zzsxgs = json['zzsxgs'];
    zzmel3 = json['zzmel3'];
    zzmel2 = json['zzmel2'];
    mandt = json['mandt'];
    zzfstnm = json['zzfstnm'];
    zzblfax = json['zzblfax'];
    deleter = json['deleter'];
    zzrepeatind = json['zzrepeatind'];
    zzblry = json['zzblry'];
    falqty = json['falqty'];
    String tempStr2=json['zzstart'];

    DateTime tempDate2=DateTime.parse(tempStr2.length>0?tempStr2:'1979-01-01');
    zzstart = DateUtil.formateYMD(tempDate2);
    zzandor = json['zzandor'];
    zzblst = json['zzblst'];
    zzmel = json['zzmel'];
    closeby = json['closeby'];
    zzbltel = json['zzbltel'];
    zziftzqp = json['zziftzqp'];
    ernam = json['ernam'];
    instqty = json['instqty'];
    zztatzj3 = json['zztatzj3'];
    zzmel4 = json['zzmel4'];
    zzfjblzfh = json['zzfjblzfh'];
    zzmel5 = json['zzmel5'];
    maintenanceby = json['maintenanceby'];
    zzamcfg = json['zzamcfg'];
    zzcluser = json['zzcluser'];
    qmnum = json['qmnum'];
    zzzgjdtel = json['zzzgjdtel'];
    zzxnsend = json['zzxnsend'];
    zzfizfxxh = json['zzfizfxxh'];
    zzbluser = json['zzbluser'];
    zzwo = json['zzwo'];
    createtime = json['createtime'];
    zzifxn = json['zzifxn'];
    processingresult = json['processingresult'];
    zzddscbgdd = json['zzddscbgdd'];
    approvedby = json['approvedby'];
    ztosocinfo = json['ztosocinfo'];
    zzuser4 = json['zzuser4'];
    zzuser3 = json['zzuser3'];
    zzuser2 = json['zzuser2'];
    zzuser1 = json['zzuser1'];
    zzmbno = json['zzmbno'];
    String tempStr3=json['zzzzsqx'];
    DateTime tempDate3=DateTime.parse(tempStr3.length>0?tempStr3:'1979-01-01');//DateTime.parse(json['zzzzsqx']);
    zzzzsqx =  DateUtil.formateYMD(tempDate3);
    toolname = json['toolname'];
    zznottoamc = json['zznottoamc'];
    zloekz = json['zloekz'];
    zzifyl = json['zzifyl'];
    ddstate = json['ddstate'];
    zznstrint = json['zznstrint'];
    rsnum = json['rsnum'];
    zzfxdt = json['zzfxdt'];
    zziftzlg = json['zziftzlg'];
    zzsecdpg = json['zzsecdpg'];
    changer = json['changer'];
    operatinglimits = json['operatinglimits'];
    applyby = json['applyby'];
    //申请日期
    String tempStr5=json['zzzzsqx'];
    DateTime tempDate5=DateTime.parse(tempStr5.length>0?tempStr5:'1979-01-01');//DateTime.parse(json['zzzzsqx']);
    applydate =  DateUtil.formateYMD(tempDate5);
    performanceresult =json['performanceresult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zzotext'] = this.zzotext;
    data['zzfjzfxxs'] = this.zzfjzfxxs;

    data['zzrescode'] = this.zzrescode;
    data['zzifrchk'] = this.zzifrchk;
    data['creater'] = this.creater;
    data['zztzxndt'] = this.zztzxndt;
    data['zzusbintervd'] = this.zzusbintervd;
    data['zzbltyp'] = this.zzbltyp;
    data['zzcldate'] = this.zzcldate;
    data['zzblno'] = this.zzblno;
    data['aedat'] = this.aedat;
    data['sernr'] = this.sernr;
    data['maintenanceunit'] = this.maintenanceunit;
    data['zzlbd'] = this.zzlbd;
    data['aenam'] = this.aenam;
    data['zzscz'] = this.zzscz;
    data['erdat'] = this.erdat;
    data['zzatazj2'] = this.zzatazj2;
    data['ddreport'] = this.ddreport;
    data['zzremark'] = this.zzremark;
    data['zzrectype'] = this.zzrectype;
    data['zzftype'] = this.zzftype;
    data['ddid'] = this.ddid;
    data['zzblclf'] = this.zzblclf;
    data['zzdate4'] = this.zzdate4;
    data['changetime'] = this.changetime;
    data['zzdefdy'] = this.zzdefdy;
    data['zzdate2'] = this.zzdate2;
    data['zztoamc'] = this.zztoamc;
    data['zzfasys'] = this.zzfasys;
    data['zzdate3'] = this.zzdate3;
    data['zzyxfwcd'] = this.zzyxfwcd;
    data['zzytsj'] = this.zzytsj;
    data['zzdate1'] = this.zzdate1;
    data['zzmsgrp'] = this.zzmsgrp;
    data['entrytype'] = this.entrytype;
    data['zzddplanner'] = this.zzddplanner;
    data['zziftzpz'] = this.zziftzpz;
    data['zzcjqmnum'] = this.zzcjqmnum;
    data['closetime'] = this.closetime;
    data['zzzzhwj'] = this.zzzzhwj;
    data['zzblfxxs'] = this.zzblfxxs;
    data['zzatazj'] = this.zzatazj;
    data['zzpcdat'] = this.zzpcdat;
    data['zzmind'] = this.zzmind;
    data['zztzpzdt'] = this.zztzpzdt;
    data['zzcomfirmbz'] = this.zzcomfirmbz;
    data['zzblfxxh'] = this.zzblfxxh;
    data['zzzgjdfax'] = this.zzzgjdfax;
    data['inspectionby'] = this.inspectionby;
    data['approveddate'] = this.approveddate;
    data['zzsbintervd'] = this.zzsbintervd;
    data['relqty'] = this.relqty;
    data['partno'] = this.partno;
    data['zzflgo'] = this.zzflgo;
    data['zzsffris'] = this.zzsffris;
    data['zztzqpdt'] = this.zztzqpdt;
    data['deletetime'] = this.deletetime;
    data['zzbgdt'] = this.zzbgdt;
    data['zzsrcobj'] = this.zzsrcobj;
    data['zzfiblzfc'] = this.zzfiblzfc;
    data['zztzlgdt'] = this.zztzlgdt;
    data['zzflgoth'] = this.zzflgoth;
    data['zzaenam'] = this.zzaenam;
    data['zztimes'] = this.zztimes;
    data['zzgzms'] = this.zzgzms;
    data['zzrefblno'] = this.zzrefblno;
    data['zzsxgs'] = this.zzsxgs;
    data['zzmel3'] = this.zzmel3;
    data['zzmel2'] = this.zzmel2;
    data['mandt'] = this.mandt;
    data['zzfstnm'] = this.zzfstnm;
    data['zzblfax'] = this.zzblfax;
    data['deleter'] = this.deleter;
    data['zzrepeatind'] = this.zzrepeatind;
    data['zzblry'] = this.zzblry;
    data['falqty'] = this.falqty;
    data['zzstart'] = this.zzstart;
    data['zzandor'] = this.zzandor;
    data['zzblst'] = this.zzblst;
    data['zzmel'] = this.zzmel;
    data['closeby'] = this.closeby;
    data['zzbltel'] = this.zzbltel;
    data['zziftzqp'] = this.zziftzqp;
    data['ernam'] = this.ernam;
    data['instqty'] = this.instqty;
    data['zztatzj3'] = this.zztatzj3;
    data['zzmel4'] = this.zzmel4;
    data['zzfjblzfh'] = this.zzfjblzfh;
    data['zzmel5'] = this.zzmel5;
    data['maintenanceby'] = this.maintenanceby;
    data['zzamcfg'] = this.zzamcfg;
    data['zzcluser'] = this.zzcluser;
    data['qmnum'] = this.qmnum;
    data['zzzgjdtel'] = this.zzzgjdtel;
    data['zzxnsend'] = this.zzxnsend;
    data['zzfizfxxh'] = this.zzfizfxxh;
    data['zzbluser'] = this.zzbluser;
    data['zzwo'] = this.zzwo;
    data['createtime'] = this.createtime;
    data['zzifxn'] = this.zzifxn;
    data['processingresult'] = this.processingresult;
    data['zzddscbgdd'] = this.zzddscbgdd;
    data['approvedby'] = this.approvedby;
    data['ztosocinfo'] = this.ztosocinfo;
    data['zzuser4'] = this.zzuser4;
    data['zzuser3'] = this.zzuser3;
    data['zzuser2'] = this.zzuser2;
    data['zzuser1'] = this.zzuser1;
    data['zzmbno'] = this.zzmbno;
    data['zzzzsqx'] = this.zzzzsqx;
    data['toolname'] = this.toolname;
    data['zznottoamc'] = this.zznottoamc;
    data['zloekz'] = this.zloekz;
    data['zzifyl'] = this.zzifyl;
    data['ddstate'] = this.ddstate;
    data['zznstrint'] = this.zznstrint;
    data['rsnum'] = this.rsnum;
    data['zzfxdt'] = this.zzfxdt;
    data['zziftzlg'] = this.zziftzlg;
    data['zzsecdpg'] = this.zzsecdpg;
    data['changer'] = this.changer;
    data['operatinglimits'] = this.operatinglimits;
    data['applyby'] = this.applyby;
    data['applydate'] = this.applydate;
    data['performanceresult'] = this.performanceresult;
    return data;
  }
}

