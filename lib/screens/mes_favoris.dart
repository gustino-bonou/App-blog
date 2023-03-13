import 'package:blog_app/screens/widget/articleItems.dart';
import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/const_entete.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/testapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../modele/carticles.dart';

class MesFavoris extends StatefulWidget {
  @override
  _MesFavoris createState() => _MesFavoris();
}

class _MesFavoris extends State<MesFavoris> {

  bool voirDetail = false;

  DocumentSnapshot? article;

  CollectionReference articlesRef = FirebaseFirestore.instance.collection('articles');
  @override

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
        drawer: MyDrawer(),
        backgroundColor: d_green,
      appBar: CustomAppBar(
        image: 'images/img_1.png',
        height: MediaQuery.of(context).size.height*0.25,
      ),



      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              EnteteListArticle(user: _user,section: "VOS FAVORIS"),

              StreamBuilder<QuerySnapshot>(
                stream: articlesRef.orderBy('datePosted', descending: true)
                    .where('likedBy', arrayContains: _user!.uid).where("isApproved", isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Article> articles = snapshot.data!.docs
                        .map((doc) => Article.fromDocument(doc))
                        .toList();
                    if(articles.isEmpty){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                              child: Text("Aucun favoris",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                          )),

                          const SizedBox(
                            height: 30,
                          ),

                          Text("Vous pourriez aimé",
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          StreamBuilder<QuerySnapshot>(
                            stream: articlesRef.orderBy('datePosted', descending: true).where('isApproved', isEqualTo: true).snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasError){
                               const  Text("Error");
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
                                        return buildArticleListItem(context, article, articlesRef);
                                      },
                                    )
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),

                        ],
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return buildArticleListItem(context, article, articlesRef);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavigation(),
    );
  }
}
