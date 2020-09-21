import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/style/index.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:photo_view/photo_view.dart';

import 'image_view_page.dart';

class ImageGridViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageGridViewPageSate();
}

class _ImageGridViewPageSate extends State<ImageGridViewPage> {
  List<VacationBean> _list = VacationBean.generate();
  bool _showDelete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              '长按删除',
              style: TextThemeStore.textStyleAppBar,
            ),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.map),
                  tooltip: '切换图片显示模式',
                  onPressed: () {})
            ],
          ),
          preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight)),
      backgroundColor: Colors.white,
      body: _imageGridViewWidget(),
    );
  }

  Widget _imageGridViewWidget() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      padding: EdgeInsets.all(4),
      children: _list.map(
        (VacationBean img) {
          return GestureDetector(
            onTap: () {
              _showPhoto(context, img);
            },
            onLongPress: () {
              setState(() {
                _showDelete = !_showDelete;
              });
            },
            child: Hero(
                tag: img.name,
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      img.url,
                      fit: BoxFit.fill,
                    ),
                    _showDelete
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  _list.remove(img);
                                });
                              },
                            ),
                          )
                        : Container()
                  ],
                )),
          );
        },
      ).toList(),
    );
  }

  void _showPhoto(BuildContext context, VacationBean img) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return GestureDetector(
        child: SizedBox.expand(
          child: Hero(
              tag: img.name,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider: NetworkImage(img.url),
                loadingChild: CircularProgressIndicator(),
                enableRotation: true,
              )),
        ),
        onTap: () {
          Navigator.maybePop(context);
        },
      );
    }));
  }
}

class VacationBean {
  String url;
  String name;

  VacationBean(this.url, this.name);

  static List<VacationBean> generate() {
    return [
      VacationBean(
          'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2607754638,3469196749&fm=26&gp=0.jpg',
          '气球14'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406738792&di=630e2fd2a488b9ef4d6a757b49fe78a7&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fbaike%2Fpic%2Fitem%2F5d6034a85edf8db1aca565710223dd54564e741f.jpg',
          '篮球13'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球12'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球11'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球10'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球9'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球8'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球7'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球6'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球5'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球4'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球3'),
      VacationBean(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585406741666&di=3617eb205b35749c88e5b7fc1d2011cb&imgtype=0&src=http%3A%2F%2Fpics2.baidu.com%2Ffeed%2F00e93901213fb80ef8bc260345eb392bb83894b0.jpeg%3Ftoken%3D86b9b7e28a64b7645b5c87855e10f23d%26s%3Df22fb044c4d80bc43db2fd1b03008099',
          '火球2'),
      VacationBean(
          'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2607754638,3469196749&fm=26&gp=0.jpg',
          '气球1'),
    ];
  }
}
