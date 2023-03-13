import 'package:blog_app/screens/widget/articleItems.dart';
import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modele/carticles.dart';


class RechercheArticle extends StatefulWidget {
   String search;
  RechercheArticle(this.search);

  @override
  _ArticleSearchState createState() => _ArticleSearchState();
}

class _ArticleSearchState extends State<RechercheArticle> {
  final TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _stream;

  CollectionReference articleRef = FirebaseFirestore.instance.collection("articles");

  bool vide  = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('articles')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    //_searchController.text = widget.search;
    return Scaffold(
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            decoration: const  BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                image: DecorationImage(
                image: AssetImage(
                    'images/sport_area.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back)),
                    TextField(
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none
                              )
                          ),
                          prefixIcon: IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.search_outlined,
                                size: 30,
                                color: Color(0xFF5F67EA),)
                          ),
                          hintText: "Serch_article",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5F67EA),
                          )

                      ),
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _stream = FirebaseFirestore.instance
                              .collection('articles')
                              .where('title', isLessThanOrEqualTo: value)
                              .where('title', isLessThanOrEqualTo: value + '\uf8ff')
                              .snapshots();
                          if(value == ""){
                            setState(() {
                              vide  = true;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                Positioned(
                    right: 12,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(Icons.mic_rounded,
                        color: Color(0xFF5F67EA),
                        size: 25,
                      ),
                    )
                )
              ],
            ),
      ),
          ],
        ),
            StreamBuilder(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<Article> articles = snapshot.data!.docs
                    .map((doc) => Article.fromDocument(doc))
                    .toList();

                return Container(
                  child: ListView.builder(
                    itemCount: articles.length,
                      shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final Article article = articles[index];

                        return buildArticleListItem(context, article, articleRef);


                    },
                  ),
                );
              },
            ),
            vide? Center(child: Text("Entrer quelque chose",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                 ),
              )
            ): const Text(""),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonNavigation(),
    );
  }
}
