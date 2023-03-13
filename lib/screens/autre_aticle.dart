import 'package:blog_app/screens/widget/articleItems.dart';
import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/header_articles_category.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modele/carticles.dart';



class AutreArticles extends StatefulWidget {
  const AutreArticles({Key? key}) : super(key: key);

  @override
  State<AutreArticles> createState() => _AutreArticles();
}

class _AutreArticles extends State<AutreArticles> {

  Article? _article;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    CollectionReference articlesRef = FirebaseFirestore.instance.collection("articles");
    return Scaffold(
      appBar: SimpleAppBar(),
        drawer: MyDrawer(),



        backgroundColor:  Color(0xFF5F67EA),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderCatArticles(category: "Read more",),

              const Padding(
                padding:  EdgeInsets.only(left: 15, top: 15),
                child:  Text("Les derniers articles",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white
                  ),
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                stream: articlesRef.orderBy('datePosted', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Article> articles = snapshot.data!.docs
                        .map((doc) => Article.fromDocument(doc))
                        .toList();
                    return Container(
                        margin: const EdgeInsets.all(15),
                        decoration:  const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          //borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return buildArticleListItem(context, article, articlesRef);
                              },
                            ),
                          ],
                        )
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),

        bottomNavigationBar: const ButtonNavigation());
  }
}
