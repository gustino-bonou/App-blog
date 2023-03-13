import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // Connexion avec le Google
  Future<UserCredential> signInWithGoogle() async {

    CollectionReference users = FirebaseFirestore.instance.collection('utilisateurs');

    if (kIsWeb) return await _auth.signInWithPopup(googleProvider);

    // Déclencher le flux d'authentification
    final googleUser = await _googleSignIn.signIn();

    // obtenir les détails d'autorisation de la demande
    final googleAuth = await googleUser!.authentication;


    // créer un nouvel identifiant
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // une fois connecté, renvoyez l'indentifiant de l'utilisateur
    return await _auth.signInWithCredential(credential);
  }
  //   // l'état de l'utilisateur en temps réel
  Stream<User?> get user => _auth.authStateChanges();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void createCollectionOnFirstSignIn(BuildContext context) async {



    // _auth.authStateChanges().listen((User? user) {
    //
    //   if (user != null) {
    //     // L'utilisateur est connecté
    //     if (user.metadata.creationTime == user.metadata.lastSignInTime) {
    //       // L'utilisateur vient de s'inscrire pour la première fois
    //       // Créer une nouvelle collection dans Firestore et y stocker les informations de l'utilisateur
    //       _db.collection('users').doc(user.uid).set({
    //         'displayName': user.displayName,
    //         'email': user.email,
    //         // ajoutez d'autres informations de l'utilisateur ici
    //       });
    //     }
    //   }
    // });
  }

  // déconnexion
  Future<void> signOut() async {
    _googleSignIn.signOut();
    return _auth.signOut();
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    // Vérifie si l'application s'exécute sur le Web.
    // Si c'est le cas, retournez immédiatement null car l'authentification par popup n'est pas prise en charge sur le Web.
    //if (kIsWeb) return null;


    // Déclencher le flux d'authentification avec l'e-mail et le mot de passe fournis.
    final googleUse = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final credential = EmailAuthProvider.credential(
        email: email,
        password: password);
    // Une fois connecté, renvoyez l'identifiant de l'utilisateur
    return googleUse;
  }
   Future signUpWithEmail(email, password) async {
     try {
       _auth.createUserWithEmailAndPassword(email: email, password: password);
     }on FirebaseAuthException catch(e){
       print(e);
     }
   }

   Future sendMailReset(email)  async {
     try {
       await _auth.sendPasswordResetEmail(email: email);
     } on FirebaseAuthException catch(e) {
       print(e);
     }

   }

}