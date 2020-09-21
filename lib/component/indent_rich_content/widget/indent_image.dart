import 'package:flutter/material.dart';
import '../layout_helper.dart';
import 'indent_rich_widget.dart';

class IndentImage extends IndentRichWidget {

  final double indent;
  final Image image;
  final void Function(Image) didClickImage;

  IndentImage({
    @required NonFinalSize size,
    @required this.indent,
    this.image,
    this.didClickImage
}):super(size:size);

  @override
  _IndentImageState createState() => _IndentImageState();
}

class _IndentImageState extends State<IndentImage> {
  @override
  Widget build(BuildContext context) {
    widget.size.width = widget.size.width / 3;
    widget.size.height = widget.size.width;


    return GestureDetector(
      child: Container(
        child: widget.image,
      ),
      onTap: (){
        if(widget.didClickImage != null){
          widget.didClickImage(widget.image);
        }
      },
    );
  }
}
