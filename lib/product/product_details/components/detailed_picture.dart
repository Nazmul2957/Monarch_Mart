import 'package:flutter/material.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';

class DetailedPicture {
  static show(BuildContext context, String imageUrl) => showDialog(
      context: context,
      builder: (context) => DetailedWindow(imageUrl: imageUrl));
}

// ignore: must_be_immutable
class DetailedWindow extends StatelessWidget {
  String imageUrl;

  DetailedWindow({required this.imageUrl});

  late double height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    return Dialog(
      elevation: 0.0,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            height: height * 70,
            child: CachedImage(imageUrl: imageUrl, boxFit: BoxFit.contain),
          ),
          Padding(
            padding: EdgeInsets.only(top: height / 4, right: height / 4),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                )),
          )
        ],
      ),
    );
  }
}
