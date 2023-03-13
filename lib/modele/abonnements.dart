import 'package:cloud_firestore/cloud_firestore.dart';

class Abonnement {

  String? id;
  List<String>? likedBy;

  Abonnement({
    required this.id,
    this.likedBy,
  });

  factory Abonnement.fromDocument(DocumentSnapshot doc) {
    return Abonnement(
      id: doc.id,
      likedBy: List<String>.from(doc['likedBy']),
    );
  }

  Map<String, dynamic> toData() => {
    'id': id,
    'likedBy': likedBy,
  };
  Map<String, dynamic> toDataWI() => {
    'likedBy': likedBy,
  };
}