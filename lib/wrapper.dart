import 'package:blog_app/screens/carticles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'modele/utilisateur.dart';
import 'screens/authentification/login_by_google.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    //CollectionReference userRef = FirebaseFirestore.instance.collection("utilisateurs");

    final firebaseUser = context.watch<User?>();

    // if(firebaseUser != null){
    //   Utilisateur utilisateur = Utilisateur(
    //       id: userRef.doc().id,
    //       name: firebaseUser!.displayName,
    //       imageUrl: firebaseUser.photoURL,
    //       email: firebaseUser.email
    //   );
    //   userRef.add(utilisateur.toData());
    // }




    //final user = Provider.of<User?>(context);

    return firebaseUser == null ? const Login() : HomePage();
  }
}
