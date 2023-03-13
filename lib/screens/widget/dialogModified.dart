import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/global.parents.dart';
import '../../main.dart';



  showDialogModifyComment(  BuildContext context, TextEditingController commentController, CollectionReference collectionReference, String id,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: d_green,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text("  "),
          titleTextStyle: TextStyle(),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 150,
            child: TextFormField(
              minLines: 3,
              maxLines: 5,
              controller: commentController,
              decoration: inputDecoration("Modifier le commentaire"),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 24.0, 0.0),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Annuler',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,

                      fontWeight: FontWeight.w700

                  ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Modifier',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,

                      fontWeight: FontWeight.w700

                    ),
                  ),
                  onPressed: () {
                    // ignore: avoid_single_cascade_in_expression_statements
                    collectionReference.doc(id).update({
                      "content": commentController.text,
                      "updateDate": Timestamp.now(),
                    }).then((value){
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      // Afficher un message d'erreur avec ScaffoldMessenger
                      ScaffoldMessenger.of(context).showSnackBar(
                       const  SnackBar(
                          width: 20,
                          duration: const Duration(seconds: 3),
                          content: Text('Une erreur est survenue '),
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