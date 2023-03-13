import 'package:blog_app/screens/widget/app_bar.dart';
import 'package:blog_app/screens/widget/articleItems.dart';
import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/on_article.dart';
import 'package:blog_app/screens/widget/testapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modele/carticles.dart';


class SportArticle extends StatefulWidget {
  const SportArticle({Key? key}) : super(key: key);

  @override
  State<SportArticle> createState() => _SportArticle();
}

class _SportArticle extends State<SportArticle> {

  Article? _article;


  Future<Article> getLateArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').where("category", isEqualTo: "Sports").where("isApproved", isEqualTo: true).orderBy("datePosted", descending: true).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles[0];
  }

  @override
  void initState() {
    // TODO: implement initState
    getLateArticlesFromCollection().then((article){
      _article = article;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    CollectionReference articlesRef = FirebaseFirestore.instance.collection("articles");
    return Scaffold(
        drawer: MyDrawer(),
        appBar: CustomAppBar(
          image: 'images/musicback.png',
          height: MediaQuery.of(context).size.height*0.25,
        ),
        backgroundColor:  Color(0xFF5F67EA),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35,),
              const Padding(
                padding:  EdgeInsets.only(left: 15),
                child:  Text("Article du jour",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    color: Colors.white
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(


                height: 300,
                decoration: const  BoxDecoration(
                    color: Color(0xFF5F67EA)
                ),
                child: ImageWithText(articleFunction: getLateArticlesFromCollection,)

              ),
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
                stream: articlesRef.orderBy('datePosted', descending: true)
                    .where('category', isEqualTo: "Sports").snapshots(),
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





