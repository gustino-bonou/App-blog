import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDecoration( String? labeltext, [Icon? icon]){
  return InputDecoration(
    //labelText: "Nom",
    suffixIcon: icon,
      labelText: labeltext,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          // width: 2,
        ),
      ),
  );
}

class GlobalParams {
   static List<Map<String, dynamic>>menus = [

     { "title":"Mes favoris", "icon": const   Icon(Icons.favorite_outline_rounded, color: Color(0xFF56002D)), "route":"/favorite", },
     { "title": "Mes articles", "icon": const Icon(Icons.article, color: Color(0xFF56002D)), "route":"/mesarticles", },
     { "title":"Ecrire", "icon":  const Icon(Icons.edit, color: Color(0xFF56002D)), "route":"/addArticle", },
     { "title":"Accueil", "icon":  const Icon(Icons.home, color: Color(0xFF56002D)), "route":"/home", },

  ];
   static final assets = Assets();
   static final colors = Colorss();
   static final onPress = Navigate();



}
//Navigation
class Navigate {
  void onPress(context, Widget page){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
  }
}
class Assets {
  final String google = "asset/images/";
}

class Colorss {
  final primaryColors = const Color(0xFF8a307f);
  final second = Color(0xFF79a7d3);
  final tsecond = Color(0xFF6883bc);
  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;
    Color pc = Color(0xFFF8D3E2);
    return MaterialColor(color.value, swatch);
  }
}

TextTheme textTheme(){
  return  TextTheme(
    headline1: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w500
    ),
    headline2: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w700
    ),
    headline3: GoogleFonts.poppins(
        color: Colors.green,
        fontSize: 32,
        fontWeight: FontWeight.bold
    ),
  );





}
Future<String?> signInWithEmail(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user?.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'Aucun utilisateur trouvé pour cet e-mail.';
    } else if (e.code == 'wrong-password') {
      return 'Le mot de passe est incorrect.';
    }
    return e.message;
  } catch (e) {
    return e.toString();
  }
}
Future<String?> signUpWithEmail(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user?.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'Le mot de passe est trop faible.';
    } else if (e.code == 'email-already-in-use') {
      return 'Cet e-mail est déjà associé à un compte.';
    }
    return e.message;
  } catch (e) {
    return e.toString();
  }
}


