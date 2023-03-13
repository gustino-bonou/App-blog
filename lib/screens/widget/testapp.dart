import 'package:blog_app/screens/widget/app_bar.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  String image;

   CustomAppBar({Key? key, required this.height, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height - kToolbarHeight,
        child: AppBar(
          //backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            // side: const BorderSide(color: Colors.green)
          ),
          toolbarHeight: 150,
          elevation: 0,
          flexibleSpace: Container(
            //margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
              image: DecorationImage(
                image: AssetImage(image, ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.amber
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          // title: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}