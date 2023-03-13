
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../modele/carticles.dart';
import '../autre_aticle.dart';
import '../musique.dart';
import '../politique.dart';
import '../sport.dart';

class CategorySection extends StatefulWidget {
   CategorySection({Key? key}) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {

  final categorie = [
    {
      'icon': Icons.sports,
      'color': const Color(0xFF605CF4),
      'title': 'Sport'
    },
    {
      'icon': Icons.public,
      'color': const Color(0xFFFC77A6),
      'title': 'Politic'
    },
    {
      'icon': Icons.music_note_outlined,
      'color': const Color(0xFF4391FF),
      'title': 'Music'
    },
    // {
    //   'icon': Icons.format_overline,
    //   'color': const Color(0xFF4399F9),
    //   'title': 'Overs'
    // },
  ];


  // 1. Créer une variable pour stocker les articles récupérés
  List<Article> _articles = [];

  Article? _article;


  Future<Article> getLateArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').where("category", isEqualTo: "Sports").orderBy("datePosted", descending: true).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles[0];
  }

  Future<List<Article>> getArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').where("category", isEqualTo: "Sports").get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles;
  }
  void navigateCategory(BuildContext context, int cat){
    switch(cat){
      case 0: {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>const SportArticle()));
      } ;
 break;
      case 1: {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>const PolitiqueArticle()
        )
        );
      }
 break;
      case 2: {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>const MusiqueArticle()
        )
        );
      }
 break;
      default: {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>const AutreArticles()
        )
        );
      }break;

    }
  }
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // 2. Appeler la fonction et stocker le résultat dans la variable _articles
    getArticlesFromCollection().then((articles) {
      setState(() {
        _articles = articles;
      });
    });
    getLateArticlesFromCollection().then((article) {
      setState(() {
        _article = article;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_itemCount);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 170,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              scrollDirection: Axis.horizontal,
                itemBuilder: (context, index)=>Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: categorie[index]['color'] as Color
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: (){
                              navigateCategory(context, index);
                            },
                            icon: Center(
                              child: Icon(
                                  categorie[index]["icon"] as IconData,
                              color: Colors.white,
                              size: 30,
                              ),
                            ),
                          ),
                        ),

                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(categorie[index]['title'] as String,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    )
                  ],
                ),
            separatorBuilder: (context, index)=> SizedBox(width: 55,),
            itemCount: categorie.length,),
          ),

        ],
      ),
    );
  }
}
