import 'package:cloud_firestore/cloud_firestore.dart';

class Article {

   String? id;
   String? title;
   String? content;
   String? imageUrl;
   String? category;
   String? userId;
   Timestamp? datePosted;
  int? likes;
   List<String>? likedBy;
   bool? isApproved;

  Article({
    this.datePosted,
    required this.id,
     this.title,
     this.content,
     this.imageUrl,
     this.category,
     this.userId,
     this.likes,
     this.likedBy,
    this.isApproved
  });

  factory Article.fromDocument(DocumentSnapshot doc) {
    return Article(
      id: doc.id,
      title: doc['title'],
      content: doc['content'],
      imageUrl: doc['imageUrl'],
      category: doc['category'],
      datePosted: doc['datePosted'],
      userId: doc["userId"],
      likes: doc['likes'],
      likedBy: List<String>.from(doc['likedBy']),
      isApproved: doc['isApproved'],

    );
  }

  Map<String, dynamic> toData() => {
    'title': title,
    'content': content,
    'imageUrl': imageUrl,
    'category': category,
    'datePosted': datePosted,
    'userId': userId,
    'likes': likes,
    'likedBy': likedBy,
    'isApproved': isApproved,
  };
   Map<String, dynamic> toDataWI() => {
     'title': title,
     'content': content,
     'imageUrl': imageUrl,
     'category': category,
     'datePosted': datePosted,
     'userId': userId,
     'likes': likes,
     'likedBy': likedBy,
     'isApproved': isApproved,
   };
}