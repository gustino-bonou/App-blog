import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/category_section.dart';
import 'package:blog_app/screens/widget/header_section.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/serch_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modele/carticles.dart';
import '../services/authentification.dart';
import 'widget/articleItems.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _articlesRef =
  FirebaseFirestore.instance.collection('articles');

  bool isFavorite = false;

  Future<Article> getLateArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').where("category", isEqualTo: "Sports").orderBy("datePosted", descending: true).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles[0];
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);




    if (_user != null && _user.metadata.creationTime == _user.metadata.lastSignInTime) {
      // L'utilisateur est connecté
        // L'utilisateur vient de s'inscrire pour la première fois
        // Créer une nouvelle collection dans Firestore et y stocker les informations de l'utilisateur
        FirebaseFirestore.instance.collection('users').add({
          'id': _user.uid,
          'displayName': _user.displayName,
          'email': _user.email,
          'imageUrl': _user.photoURL,
          // ajoutez d'autres informations de l'utilisateur ici
        });
    }

    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor:  const Color(0xFF5F67EA),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Transform(
                      transform: Matrix4.identity()..rotateZ(20),
                  origin: const Offset(150, 50),
                    child: Image.asset("images/backgound.png",
                    width: 200,
                    ),
                  ),
                  Positioned(
                    right: 0,
                      top: 200,
                      child: Transform(
                        transform: Matrix4.identity()..rotateZ(20),
                        origin: const Offset(150, 150),
                        child: Image.asset("images/backgound.png",
                          width: 150,
                        ),
                      ),
                  ),
                  Column(
                    children:  [
                      const HeaderSection(),
                      const SearchSection(),
                      CategorySection(),

                      // Container(
                      //   color: Colors.white,
                      //   child: PopularArticles(),
                      // ),
                      Container(
                        color: Colors.white,
                        child:
                        StreamBuilder<QuerySnapshot>(
                          stream: _articlesRef.orderBy('datePosted', descending: true).where('isApproved', isEqualTo: true).snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasError){
                              Text("Error");
                            }
                            if (snapshot.hasData) {
                              final List<Article> articles = snapshot.data!.docs
                                  .map((doc) => Article.fromDocument(doc))
                                  .toList();
                              return Container(
                                  //margin: const EdgeInsets.only(top: 15),
                                  decoration:  const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                    //borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      final article = articles[index];
                                      return buildArticleListItem(context, article, _articlesRef);
                                    },
                                  )
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //ListFavoriteArticles(),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      bottomNavigationBar: const ButtonNavigation(),
    );
  }

//
// void funt(){
//   StreamBuilder<QuerySnapshot>(
//     stream: _articlesRef.orderBy("datePosted", descending: true).snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         final List<Article> articles = snapshot.data!.docs
//             .map((doc) => Article.fromDocument(doc))
//             .toList();
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: articles.length,
//           itemBuilder: (context, index) {
//             final article = articles[index];
//             return buildArticleListItem(context, article, _articlesRef);
//           },
//         );
//       } else {
//         return const Center(child: CircularProgressIndicator());
//       }
//     },
//   );
// }
}