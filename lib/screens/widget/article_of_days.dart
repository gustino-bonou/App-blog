import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../modele/carticles.dart';
import '../../util/format_date.dart';
import '../detail_article.dart';

class ArticleOfDay extends StatefulWidget {
  final Future<Article> Function() articleFunction;

  ArticleOfDay({required this.articleFunction});

  @override
  State<ArticleOfDay> createState() => _ArticleOfDay();
}

class _ArticleOfDay extends State<ArticleOfDay> {

  Future<Article> getLateArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').orderBy("datePosted", descending: true).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles[0];
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFFF6F8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Articles of the days",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: widget.articleFunction(),
              builder: (BuildContext context, AsyncSnapshot<Article> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }else if(snapshot.hasError) {
                  return Container();
                }else {
                  String title = snapshot.data!.title!;
                  if(title.length>55 ){
                    title = "${title.substring(0, 49)}...";
                  }
                  return InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>
                              DetailArticle(artid: snapshot.data!.id!)
                          ));
                    },
                    child: Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          snapshot.data!.imageUrl == null ? Container(
                            color: Colors.grey,
                          ):
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 250,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                child: Image.network(
                                  snapshot.data!.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.content!,
                              style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.justify,
                              ),
                              Text(formateDate(snapshot.data!.datePosted!),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                              ),
                              )
                            ],
                          )
                        ],
                      ),
                    )

                  );
                }
              }
          ),
        ],
      ),
    );
  }
}
