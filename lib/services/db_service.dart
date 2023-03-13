
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import '../modele/utilisateur.dart';

import 'package:flutter/material.dart';

import '../util/show_snackbar.dart';


Future<Utilisateur?> getUserByArticleId(String articleId) async {
  final articleSnapshot = await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .get();

    final userId = articleSnapshot['userId'] as String;

    final userSnapshot = await FirebaseFirestore.instance
        .collection('users').where('id', isEqualTo: userId)
        .get();
    if(userSnapshot.size>=1){
      if (userSnapshot.docs[0].exists) {
        final userData = userSnapshot.docs[0];
        return Utilisateur(
          id: userId,
          name: userData['name'] as String,
          email: userData['email'] as String,
          imageUrl: userData['imageUrl'] ?? '',
        );
      }
    }
  return null;
}

deleteArticle(BuildContext context, CollectionReference collectionReference, id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: d_green,
        scrollable: true,
        title: const  Text("Vouler vous supprimer cet article ?"),

        contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 24.0, 0.0),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text('Annuler',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,

                        fontWeight: FontWeight.w700

                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Supprimer',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w700

                    )
                ),
                onPressed: () {
                  // ignore: avoid_single_cascade_in_expression_statements
                  collectionReference.doc(id).delete()..then((value) {
                    // Afficher un message de succès avec ScaffoldMessenger
                    Utils.showSnack(context, "Article supprimé avec succès");
                    Navigator.pop(context);
                  }).catchError((error) {
                    // Afficher un message d'erreur avec ScaffoldMessenger
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        width: 20,
                        duration: const Duration(seconds: 4),
                        content: Text('Une erreur s\'est produite : $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
              )
            ],
          ),
        ],
      );
    },
  );
}

void deleteCooment(BuildContext context, String articleId, String commentId){
  // ignore: avoid_single_cascade_in_expression_statements
  FirebaseFirestore.instance.collection("articles").doc(articleId).collection("commentaires").doc(commentId).delete()..then((value) {
    // Afficher un message de succès avec ScaffoldMessenger
    Utils.showSnack(context, "Commentaire supprimé avec succès");
  }).catchError((error) {
    // Afficher un message d'erreur avec ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 20,
        duration: const Duration(seconds: 4),
        content: Text('Une erreur s\'est produite : $error'),
        backgroundColor: Colors.red,
      ),
    );
  });
}
void updateArticle(BuildContext context, title, content, cat, docId){
  // ignore: avoid_single_cascade_in_expression_statements
  FirebaseFirestore.instance.collection("articles").doc(docId).update({
    "category": cat,
    "title":title,
    "content": content,
  })..then((value) {
    // Afficher un message de succès avec ScaffoldMessenger
    Utils.showSnack(context, "Mise à jour effectuée avec succès");
    Navigator.pop(context);
  }).then((value){

  })  .catchError((error) {
    // Afficher un message d'erreur avec ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 20,
        duration: const Duration(seconds: 4),
        content: Text('Erreur lors de la mise à jour : $error'),
        backgroundColor: Colors.red,
      ),
    );
  });
}

Future<bool> isSuperUser() async {

  bool isSuper = false;

  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("supers_users").doc(FirebaseAuth.instance.currentUser!.uid).get();

  if(documentSnapshot.exists){
    isSuper = true;
  }

  return isSuper;
}

Stream<int> streamUnapprovedArticleCount() {
  return FirebaseFirestore.instance
      .collection('articles')
      .where('isApproved', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}

void addUser(BuildContext context, User user,) async {

  Utilisateur utilisateur = Utilisateur(
    id: user.uid,
    name: user.displayName,
    email: user.email,
    imageUrl: user.photoURL,
  );

  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where("id", isEqualTo: user.uid).get();
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();


  if (!documentSnapshot.exists) {

    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDocRef.set(
        utilisateur.toData()
    );
    //FirebaseFirestore.instance.collection('users').add(utilisateur.toData());
  }
}