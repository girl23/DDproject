//圆圈工具类
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:lop/config/enum_config.dart';
class CirclePainter extends CustomPainter {
  final List <Color>colors;
  final List <double>percent;
  final bool filled ;
  final Offset center;
  final double radius;
  final double strokeWidth;
  final Size canvasSize;
  JobCardLanguage cardLanguage;
  ///[定义画笔]
  Paint _paint1;
  double _startAngle;
  CirclePainter(this.colors,this.percent,this.canvasSize,{this.cardLanguage=JobCardLanguage.cn, this.filled=false, this.strokeWidth=15.0,double startAngle=pi/2,this.center=const Offset(150.0,150.0),this.radius=100}){
//    print('filled2222$filled');
    _startAngle=startAngle;
  }
  @override
  void addListener(listener) {
    // TODO: implement addListener
    super.addListener(listener);
//    print('fill4444$filled');
  }
  //段落构造器
  ui.ParagraphBuilder _paragraph_builder;

  ui.Paragraph _paragraph;
  @override
  void paint(Canvas canvas, Size size) {
//    print('size${size.width}/${size.height}');
    _paint1= Paint()
      ..strokeCap = StrokeCap.butt//画笔笔触类型
      ..isAntiAlias = true //是否启动抗锯齿
      ..style =(filled)?PaintingStyle.fill:PaintingStyle.stroke //绘画风格，默认为填充PaintStyle.stroke 不填充,PaintingStyle.fill 填充
      ..strokeWidth =this.strokeWidth; //画笔的宽度
    Rect rect2 = Rect.fromCircle(center: this.center, radius: this.radius);
    //    根据定义，一周的弧度数为2πr/r=2π，360°角=2π弧度，因此，1弧度约为57.3°，即57°17’44.806’’，
//    1°为π/180弧度，近似值为0.01745弧度，周角为2π弧度，平角（即180°角）为π弧度，直角为π/2弧度。
    //rect2矩型区域，起始点，化的幅度，是否连接中心原点

    //将360平均分层100分*乘以每一份占的弧度，再乘以100份中占了多少份

//    角度=180°×弧度÷π   弧度=角度×π÷180°
    double completeRadian=0.0;//统计总共完成绘制的弧度
    double textWidth=70;//文本宽度(刚好放下四个汉字)
    double textHeight=28;//文本高度
    double distance=10;//文本矩圆弧的距离
    double marginHeight=(canvasSize.height-2*radius)/2.0;
    double R=radius+distance;

    //圈外文字
    double outFontSizeCharacter=14;
    double outFontSizeNum=10;
    //圈内文字
    double inFontSizeCharacter=16;
    double inFontSizeNum=14;

    double normalSignOffsetDyTop=0;//正常签的顶部偏移

//    double tempNormalSignOffsetDy;
    paintCharacter(List para,Offset characterOffset,{bool center,bool putRight}){


      for(int i=0;i<2;i++){
        // 文字左上角起始点
        Offset offset;
        double fontSize;
        FontWeight fontWeight;
        double y=characterOffset.dy;
        if(i==0){
//          print('===文字=yoffset$y');
          //文字
          fontSize=(center!=null&&center)?inFontSizeCharacter:outFontSizeCharacter;
          offset =Offset(characterOffset.dx,y+outFontSizeNum);
        }else{
          //百分比
//          print('===百分比=yoffset$y');
          fontSize=(center!=null&&center)?inFontSizeNum:outFontSizeNum;
          offset=Offset(characterOffset.dx,(center!=null&&center)?y-5:y);
        }
        //  创建段落构造器
        _paragraph_builder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: (center!=null&&center)?TextAlign.center:(putRight!=null&&putRight)?TextAlign.left:TextAlign.right,
            fontSize: fontSize,
            fontWeight: (center!=null&&center&&i==1)?FontWeight.bold:fontWeight,
            textDirection: TextDirection.ltr,
//        maxLines: 5,
          ),
        );

        _paragraph_builder.pushStyle(
            ui.TextStyle(
                color: Colors.white,
                textBaseline: ui.TextBaseline.alphabetic
            ));
        //添加要绘制的文本内容
        _paragraph_builder.addText(para[i]);

        //    构建段落
        _paragraph = _paragraph_builder.build();
        //设置文本的宽度约束
        ui.ParagraphConstraints constraint= ui.ParagraphConstraints(width:(center!=null&&center)?radius*2:textWidth);
        // 这里需要先layout,将宽度约束填入，否则无法绘制
        _paragraph.layout(constraint);
        //开始绘制
        canvas.drawParagraph(
            _paragraph,offset);
      }
    }


    for (int i=0;i<colors.length;i++){

      //即将绘制的弧度
      double radian=(360.0/100.0)*pi/180.0*percent[i];
      if (radian==0){
        continue;
      }
      Color drawColor=colors[i];
      _paint1.color=drawColor;

      canvas.drawArc(rect2,_startAngle+completeRadian , radian, this.filled, _paint1);


      double tempStartRadian=completeRadian;//记录上次完成的弧度
      //总计完成绘制的弧度
      completeRadian+=radian;

      if(i==0){
        //正常签
        if (radian==0){
          return;
        }
        double horizonDistance=R*sin(radian/2.0);

        double dx=canvasSize.width/2.0-textWidth-horizonDistance;

        double verticalDistance=R-R*cos(radian/2.0);

        //高于中间轴后的细节处理
        double otherHeight=0;
        if(radian>pi){
          otherHeight=textHeight*(radian/(2*pi));
        }
        double dy=canvasSize.height-marginHeight-verticalDistance+distance-otherHeight;

        //
        normalSignOffsetDyTop=dy;

        double addDy=0;
        //判断底部是否超出画布
        if(dy+textHeight>canvasSize.height){
          dy=canvasSize.height-textHeight;
        }
        //顶部是否超出画布
        if(dy<0){
          dy=5;
        }
        //左边是否超出画布
        if(dx<0){
          dx=5;
        }
        //右边是否超出画布
        if(dx+textWidth>canvasSize.width){
          dx=canvasSize.width-textWidth-5;
        }

        paintCharacter([this.cardLanguage==JobCardLanguage.en?'NORMAL':'正常签名','${percent[0]}%'],Offset(dx,dy));

      }
      else if(i==1){

////        NA签
        double completeAngle=completeRadian*180/pi;
        double tempStartAngle=tempStartRadian*180/pi;
        double radianAngle=radian*180/pi;
//        print('radianAngle:$radianAngle' );
//        print('tempStartAngle:$tempStartAngle' );
//        print('=====completeAngle:$completeAngle' );
//        print('=====completeRadian-radian/2.0:${completeRadian-radian/2.0}' );
//        print('=====pi/2.0:${pi/2.0}=====pi$pi=====pi*3/2.0${3*pi/2.0}=====2pi${2*pi}' );
        
        if(double.parse((completeRadian-radian/2.0).toStringAsFixed(4)) <=double.parse((pi/2.0).toStringAsFixed(4)) ){
//          print('针对签名位置在0-90度以下度位置');
          double x=R*cos(pi/2.0-tempStartRadian-radian/2.0);
          double y=R*sin(pi/2.0-tempStartRadian-radian/2.0);
          double dx=canvasSize.width/2.0-textWidth-x;
          double dy=canvasSize.height-(radius+marginHeight-y);
          double addDy=0;
          //5为下边间距
          //当N/A签与正常签有重合
          if(dy+textHeight>normalSignOffsetDyTop){
            //重合部分高度
            addDy=dy+textHeight-normalSignOffsetDyTop+1;//5为间隙
          }
          double realDy=dy-addDy;
          double realDx=dx-addDy-15;

          if(realDy+textHeight+5>canvasSize.height){
            realDy=canvasSize.height-textHeight-5;
          }
          if(realDy<0){
            realDy=5;
          }
          if(realDx<0){
            realDx=5;
          }
          if(realDx>canvasSize.width){
            realDx=canvasSize.width-textWidth-5;
          }
          paintCharacter([ this.cardLanguage==JobCardLanguage.en?'N/A':'N/A签名','${percent[1]}%'],Offset(realDx,realDy));

        }
        if( double.parse((completeRadian-radian/2.0).toStringAsFixed(4))>double.parse((pi/2.0).toStringAsFixed(4))&&double.parse((completeRadian-radian/2.0).toStringAsFixed(4))<=double.parse((pi).toStringAsFixed(4))){
//          print('针对签名位置在90-180度以上度位置');
          double x=R*cos(tempStartRadian+radian/2.0-pi/2.0);
          double y=R*sin(tempStartRadian+radian/2.0-pi/2.0);
          double dx=canvasSize.width/2.0-textWidth-x-20;
          double dy=canvasSize.height-(radius+marginHeight+y)-outFontSizeNum-10;
          double addDy=0;
          //5为下边间距
          //当N/A签与正常签有重合
          if(dy+textHeight>normalSignOffsetDyTop){
            //重合部分高度
            addDy=dy+textHeight-normalSignOffsetDyTop+1;//5为间隙
          }
          double realDy=dy-addDy;
          double realDx=dx;
          if(addDy>0.0){
            realDx=dx-addDy-15;
          }

          if(realDy+textHeight+5>canvasSize.height){
            realDy=canvasSize.height-textHeight-5;
          }
          if(realDy<0){
            realDy=5;
          }

          if(realDx<0){
            realDx=5;
          }
          if(realDx>canvasSize.width){
            realDx=canvasSize.width-textWidth-5;
          }
          paintCharacter([this.cardLanguage==JobCardLanguage.en? 'N/A':'N/A签名','${percent[1]}%'],Offset(realDx,realDy));
        }
        if(double.parse((completeRadian-radian/2.0).toStringAsFixed(4))>double.parse(pi.toStringAsFixed(4))&&double.parse((completeRadian-radian/2.0).toStringAsFixed(4))<=double.parse((3*pi/2.0).toStringAsFixed(4))){

//          print('针对签名位置在180-270度以上度位置');
          double x=R*sin(tempStartRadian+radian/2.0-pi);
          double y=R*cos(tempStartRadian+radian/2.0-pi);
          double dx=canvasSize.width/2.0+x+15;
          double dy=canvasSize.height-(radius+marginHeight+y)-textHeight;
          //5为下边间距
          //当N/A签与正常签有重合

          double realDy=dy;
          double realDx=dx;

          if(realDy+textHeight+5>canvasSize.height){
            realDy=canvasSize.height-textHeight-5;
          }
          if(realDy<0){
            realDy=5;
          }

          if(realDx<canvasSize.width/2.0){
            realDx=5+canvasSize.width/2.0;
          }
          if(realDx>canvasSize.width){
            realDx=canvasSize.width-textWidth-5;
          }
          paintCharacter([this.cardLanguage==JobCardLanguage.en? 'N/A':'N/A签名','${percent[1]}%'],Offset(realDx-15,realDy),putRight:true);
        }
        if(double.parse((completeRadian-radian/2.0).toStringAsFixed(4))>double.parse((3*pi/2.0).toStringAsFixed(4)) &&double.parse((completeRadian).toStringAsFixed(4))<=double.parse((2*pi).toStringAsFixed(4))){
//          print('针对签名位置在270度以上度位置');
          double x=R*cos(tempStartRadian+radian/2.0-3*pi/2.0);
          double y=R*sin(tempStartRadian+radian/2.0-3*pi/2.0);
          double dx=canvasSize.width/2.0+x;
          double dy=canvasSize.height-(radius+marginHeight-y)-textHeight;

          double realDy=dy;
          double realDx=dx;

          if(realDy+textHeight+5>canvasSize.height){
            realDy=canvasSize.height-textHeight-5;
          }
          if(realDy<0){
            realDy=5;
          }

          if(realDx<canvasSize.width/2.0){
            realDx=5+canvasSize.width/2.0;
          }
          if(realDx>canvasSize.width){
            realDx=canvasSize.width-textWidth-5;
          }
          //高于中间轴后的细节处理

          paintCharacter([this.cardLanguage==JobCardLanguage.en? 'N/A':'N/A签名','${percent[1]}%'],Offset(realDx,realDy+textHeight),putRight:true);
        }
      }

      //全部签
      double y=canvasSize.height/2.0-textHeight/2.0;
      paintCharacter([this.cardLanguage==JobCardLanguage.en? 'ALL':'全部签名','${percent[0]+percent[1]}%'],Offset(canvasSize.width/2.0-radius,y),center: true);

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
//    return true;
//    在这个函数中，你应该返回true或false。如果你的绘画依赖于一个变量并且该变量发生了变化，那么你在这里返回true，
//    这样Flutter就知道它必须调用paint方法来重绘你的绘画。否则，在此处返回false表示您不需要重绘。

  }
}