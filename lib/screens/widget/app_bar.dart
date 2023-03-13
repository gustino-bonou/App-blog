import 'package:flutter/material.dart';

class PersAppBar extends StatefulWidget implements PreferredSizeWidget{
  String image;
  PersAppBar({Key? key, required this.image}) : super(key: key);

  @override
  State<PersAppBar> createState() => _PersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}



class _PersAppBarState extends State<PersAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              image: AssetImage(widget.image, ),
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
    );
  }
}
