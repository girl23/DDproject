class DDPublicModel{
  String result;
  String serialnumber;


  DDPublicModel({this.result,this.serialnumber});

  DDPublicModel.fromJson(Map<String, dynamic> json) {

    result = json['result'];
    serialnumber = json['serialnumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['serialnumber']=this.serialnumber;
    return data;
  }
}