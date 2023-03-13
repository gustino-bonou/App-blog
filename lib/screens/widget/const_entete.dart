import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnteteListArticle extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final String? section;

  const EnteteListArticle({Key? key, this.user, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ThemeManager _themeManager = ThemeManager();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(section!,
            style: GoogleFonts.poppins(
                color: Colors.green,
                fontSize: 32,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.start,
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueGrey,
            backgroundImage: NetworkImage(user!.photoURL!,),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
