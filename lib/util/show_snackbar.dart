import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static showSnack(BuildContext context, String? message){
    if(message == null) return;

    final snackBar = SnackBar(content: Text(message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
       snackBar,
    );


  }

  final firstStyle = GoogleFonts.poppins(
      color: Colors.green,
      fontSize: 32,
      fontWeight: FontWeight.bold
  );

}