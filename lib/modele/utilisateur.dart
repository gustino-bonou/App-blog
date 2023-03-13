import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {

  String? id;
  String? name;
  String? imageUrl;
  String? email;

  Utilisateur({
     this.id,
    this.name,
    this.imageUrl,
    this.email,
  });

  factory Utilisateur.fromDocument(DocumentSnapshot doc) {
    return Utilisateur(
      id: doc.id,
      name: doc['name'],
      imageUrl: doc['imageUrl'],
      email: doc['email'],
    );
  }

  Map<String, dynamic> toData() => {
    'id': id,
    'imageUrl': imageUrl,
    'name': name,
    'email': email,
  };
  // Map<String, dynamic> toDataWI() => {
  //   'content': content,
  //   'imageUrl': imageUrl,
  //   'datePosted': datePosted,
  //   'userId': userId,
  //   'likes': likes,
  //   'likedBy': likedBy,
  // };
}