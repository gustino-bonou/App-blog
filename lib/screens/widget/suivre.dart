import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modele/abonnements.dart';

class BouttonSsuivre extends StatefulWidget {
  String idAuteurSuivi;
  BouttonSsuivre({Key? key, required this.idAuteurSuivi}) : super(key: key);

  @override
  State<BouttonSsuivre> createState() => _BouttonSsuivreState();
}

class _BouttonSsuivreState extends State<BouttonSsuivre> {

  CollectionReference? abonnements;
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

    return TextButton(
      onPressed: () {
        ajouterArticleSuivi(context, _user!);
      },
      child: Text(isFollowing ? "Suivi" : "Suivre",
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    abonnements = FirebaseFirestore.instance.collection("abonnements");
    verifierAbonnement(FirebaseAuth.instance.currentUser!);
  }

  void verifierAbonnement(User user) async {
    DocumentSnapshot documentSnapshot = await abonnements!.doc(user.uid).get();
    if (documentSnapshot.exists) {
      List<dynamic> likedBy = Abonnement
          .fromDocument(documentSnapshot)
          .likedBy!
          .toList();
      setState(() {
        isFollowing = likedBy.contains(widget.idAuteurSuivi);
      });
    }


    // QuerySnapshot querySnapshot = await abonnements!.where("id", isEqualTo: user.uid).get();
    // if (querySnapshot.docs.isNotEmpty) {
    //   List<dynamic> likedBy = querySnapshot.docs[0]['likedBy'];
    //   setState(() {
    //     isFollowing = likedBy.contains(widget.idAuteurSuivi);
    //   });
    // }
  }

  void ajouterArticleSuivi(BuildContext context, User user) async {
    Abonnement abonnement = Abonnement(
      id: user.uid,
      likedBy: [widget.idAuteurSuivi,],
    );

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
    //     'abonnements').where("id", isEqualTo: user.uid).get();

    DocumentSnapshot documentSnapshot = await abonnements!.doc(user.uid).get();

    if (!documentSnapshot.exists) {
      abonnements!.doc(user.uid).set(abonnement.toData());
      setState(() {
        isFollowing = true;
      });
    } else {
        String documentId = Abonnement.fromDocument(documentSnapshot).id!;
        List<dynamic> likedBy = Abonnement.fromDocument(documentSnapshot).likedBy!.toList();
        if (likedBy.contains(widget.idAuteurSuivi)) {
          await abonnements!.doc(documentId).update({
            'likedBy': FieldValue.arrayRemove([widget.idAuteurSuivi])
          });
          setState(() {
            isFollowing = false;
          });
        } else {
          await FirebaseFirestore.instance.collection('abonnements').doc(documentId).update({
            'likedBy': FieldValue.arrayUnion([widget.idAuteurSuivi])
          });
          setState(() {
            isFollowing = true;
          });
        }
    }

      // if (querySnapshot.docs.isEmpty) {
      //   abonnements!.add(abonnement.toData());
      //   setState(() {
      //     isFollowing = true;
      //   });
      // } else {
      //   if (querySnapshot.docChanges.length == 1) {
      //     String documentId = querySnapshot.docChanges[0].doc.id;
      //     List<dynamic> likedBy = querySnapshot.docs[0]['likedBy'];
      //     if (likedBy.contains(widget.idAuteurSuivi)) {
      //       await FirebaseFirestore.instance.collection('abonnements').doc(documentId).update({
      //         'likedBy': FieldValue.arrayRemove([widget.idAuteurSuivi])
      //       });
      //       setState(() {
      //         isFollowing = false;
      //       });
      //     } else {
      //       await FirebaseFirestore.instance.collection('abonnements').doc(documentId).update({
      //         'likedBy': FieldValue.arrayUnion([widget.idAuteurSuivi])
      //       });
      //       setState(() {
      //         isFollowing = true;
      //       });
      //     }
      //   }
      // }
     }
  }


// exports.sendNotifications = functions.firestore
//     .document('articles/{articleId}')
// .onCreate((snapshot, context) => {
// // Récupérer l'ID de l'auteur de l'article
// const authorId = snapshot.data().authorId;
//
// // Rechercher les documents dans la collection d'abonnements qui contiennent l'ID de l'auteur
// const query = admin.firestore().collection('abonnements').where('likedBy', 'array-contains', authorId);
//
// // Récupérer les documents qui correspondent à la requête
// return query.get().then(querySnapshot => {
// // Pour chaque document, récupérer l'ID de l'utilisateur et envoyer une notification
// querySnapshot.forEach(doc => {
// const userId = doc.data().id;
// sendNotification(userId, snapshot.data());
// });
// });
// });
//
// function sendNotification(userId, articleData) {
//   // Envoyer une notification à l'utilisateur avec l'ID userId
//   // Utiliser un service de notification tiers comme Firebase Cloud Messaging (FCM) pour envoyer la notification
//   // La variable articleData contient les données de l'article (ID de l'auteur, contenu, date de publication, etc.)
// }

