
import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/comment_items.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/simple_app_bar.dart';
import 'package:blog_app/screens/widget/suivre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../modele/carticles.dart';
import '../modele/commentaire.modele.dart';
import '../modele/utilisateur.dart';
import '../services/db_service.dart';
import '../util/format_date.dart';
import 'modifier_article.dart';

class DetailArticle extends StatefulWidget {
  String artid;
  DetailArticle({Key? key, required this.artid}) : super(key: key);

  @override
  State<DetailArticle> createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {

  CollectionReference articlesRef = FirebaseFirestore.instance.collection("articles");
  CollectionReference? commentairesRef;

  bool isLoved = false;

  bool isFavorite = false;



  final articleValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(1, errorText: 'Content must be at least 200 digits long'),
  ]);




  TextEditingController commentController = TextEditingController();



  String? commentaire;

  final formkey = GlobalKey<FormState>();



  CollectionReference articleRef = FirebaseFirestore.instance.collection("articles");

  bool isLike = true;

  bool upComment = false;

   Utilisateur _author = Utilisateur();

  Future<void> _loadAuthor() async {
    final author = await getUserByArticleId(widget.artid);
    if (author != null) {
      setState(() {
        _author = author;
      });
    } else {
      print('Aucun utilisateur trouvé pour cet article');
    }
  }

  CollectionReference superUserRef = FirebaseFirestore.instance.collection("supers_users");

  // Future<bool> isSuperUser() async {
  //
  //   bool isSuper = false;
  //
  //   DocumentSnapshot documentSnapshot = await superUserRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
  //
  //   if(documentSnapshot.exists){
  //     isSuper = true;
  //   }
  //
  //   return isSuper;
  // }

  // Future<List<Utilisateur>> getSuperUser() async {
  //   List<Utilisateur> superutilisateurs = [];
  //   QuerySnapshot querySnapshot = await superUserRef.get();
  //   querySnapshot.docs.forEach((article) {
  //     //articles.add(article.data());
  //     superutilisateurs.add(Utilisateur.fromDocument(article));
  //   });
  //   return superutilisateurs;
  // }

  bool _estSuper = false;



  @override
  void initState() {
    // TODO: implement initState

    _loadAuthor();

    isSuperUser().then((value){
      setState(() {
      _estSuper = value;
      });
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    return Scaffold(
      drawer: MyDrawer(),
      bottomNavigationBar: ButtonNavigation(),
      appBar: SimpleAppBar(),
      backgroundColor: Color(0xFFF6F8FF),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Text("data"),

          StreamBuilder<DocumentSnapshot>(
          stream: articleRef.doc(widget.artid).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final Article article = Article.fromDocument(snapshot.data!);

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        Center(
                          child: Text(article.title ?? "",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline2,
                            textAlign: TextAlign.justify,

                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 250,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                            child: article.imageUrl != null ? Image.network(
                                article.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                  );
                                }
                            ):Container(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        article.content != null ?
                        Text(article.content ?? "",
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.justify,
                        ): const Text(""),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formateDate(article.datePosted!),

                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  fontWeight: FontWeight.w500
                                )
                            ) ,
                            Row(
                              children: [
                                IconButton(
                                    onPressed: (){

                                      _likeArticle(context, articleRef, widget.artid, user.uid);
                                      isFavorite = !isFavorite;
                                      print(isFavorite);
                                    },
                                    icon:  Icon(Icons.favorite_outline,
                                      color: article.likedBy!.contains(user!.uid)
                                          ? Colors.red
                                          : Colors.grey.shade700,
                                    )
                                ),
                                Text(article.likes.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                  FutureBuilder<Utilisateur?>(
                    future: getUserByArticleId(widget.artid),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child:  CircularProgressIndicator(),);
                        }else if(snapshot.hasData){
                          final utilisateur = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Auteur",
                                style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      utilisateur.imageUrl != null && utilisateur.imageUrl != "" ?
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(utilisateur.imageUrl!)
                                      ): const Text(""),

                                      const SizedBox(
                                        width: 15,
                                      ),

                                      utilisateur.name != null?
                                      Text("${utilisateur.name}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ): const Text(""),
                                    ],
                                  ),

                                  BouttonSsuivre(idAuteurSuivi: utilisateur.id!,),
                                ],
                              ),
                            ],
                          );
                        }else{
                          return const Text("");
                        }
                      }
                    ),

                        const SizedBox(
                          height: 25,
                        ),

                        _estSuper? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                deleteArticle(context, articleRef, widget.artid);
                              },
                              child:  Text("Supprimer cet article",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 24
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ModifierArticle(idArticle: widget.artid, titleArticle: article.title!, contentArticle: article.content!)));
                              },
                              child:  Text("Modifier cet article",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 24
                                ),
                              ),
                            )

                          ],
                        )


                            :


                        Text(""),


                        const SizedBox(
                          height: 25,
                        ),

                        Form(
                          key: formkey,
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 2,
                            controller: commentController,
                            decoration: InputDecoration(
                                hintText: "Votre commentaire",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (formkey.currentState!
                                          .validate()) {
                                        _uploadComment(user);
                                        commentController.text = "";
                                      }
                                    },
                                    icon: const Icon(Icons.send)
                                )
                            ),
                            validator: articleValidator,
                              style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54)
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        )

                      ]
                  )
              );
              }
            },
          ),
              StreamBuilder<QuerySnapshot>(
                stream: articlesRef.doc(widget.artid).collection("commentaires").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Comment> comments = snapshot.data!.docs
                        .map((doc) => Comment.fromDocument(doc))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        CollectionReference commentRef = articleRef.doc(widget.artid).collection("commentaires");
                        return BuildCommentsItems(context: context, comment: comment, collectionReference: commentRef,articleID: widget.artid,);

                          //buildCommentItem(context, comment, commentRef);
                      },
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
             // APropos(),

            ],
          ),
        ),
      ),
    );
  }
  Future _uploadComment(User user) async {
    CollectionReference commentaireRef = articlesRef.doc(widget.artid).collection("commentaires");
    Comment comment = Comment(
      id: commentaireRef.doc().id,
      content: commentController.text,
      imageUrl: user.photoURL,
      userId: user.uid,
      datePosted: Timestamp.now(),
      likes: 0,
      likedBy: []
    ) ;

    await commentaireRef.add(comment.toData()).catchError((onError)=>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 20,
            duration:  Duration(seconds: 2),
            content: Text('Une erreur s\'est produite'),
          ),
        ),
    ) ;
  }

  Future<void> _likeArticle(BuildContext context,CollectionReference collection,  articleid, currentUserId) async {
    final articleRef = collection.doc(articleid);
    articleRef.get().then((doc) {
      final article = Article.fromDocument(doc);
      if (article.likedBy!.contains(currentUserId)) {

        article.likes= article.likes!-1;
        article.likedBy!.remove(currentUserId);

      } else {

        article.likes = article.likes!+1;
        article.likedBy!.add(currentUserId);

      }
      articleRef.set(article.toData());
    });
  }
}



