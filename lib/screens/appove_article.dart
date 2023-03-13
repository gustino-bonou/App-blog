import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/const_entete.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/util/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import 'detail_article.dart';
import 'modifier_article.dart';

class ApproveArticle extends StatefulWidget {
  const ApproveArticle({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ApproveArticle createState() => _ApproveArticle();
}

class _ApproveArticle extends State<ApproveArticle> {

  bool voirDetail = false;

  DocumentSnapshot? article;

  CollectionReference articlesRef = FirebaseFirestore.instance.collection('articles');
  @override

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
        bottomNavigationBar: ButtonNavigation(),
        drawer: MyDrawer(),
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Column(
            children: [

              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Container(
                  height: 250,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('images/img.png'))
                  ),
                ),
              ),


              Text("Article non approvés",
                style: GoogleFonts.poppins(
                  color: Colors.deepOrangeAccent.withOpacity(0.7),
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              StreamBuilder(
                stream: articlesRef
                    .orderBy('datePosted', descending: true)
                    .where('isApproved', isEqualTo: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Une erreur s\'est produite'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Chargement des articles...'));
                  }


                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map artMap = (document.data() as Map<String, dynamic>);


                      //String date = formateDate(artMap["date"]);

                      if(snapshot.data!.docs.isEmpty){
                        return Center(
                          child: Text("Aucun",
                            style: Theme.of(context).textTheme.headline3),
                        );
                      }

                      return Card(
                        margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              artMap["imageUrl"] != null ?   ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    child: Image.network(
                                      artMap["imageUrl"],
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                                        return Container(
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  )
                              ):Container(),
                              const SizedBox(
                                height: 15,
                              ),
                              artMap["title"] != null ?
                              Text(artMap["title"],
                                style: Theme.of(context).textTheme.headline2,
                                textAlign: TextAlign.justify,
                              ):const Text(""),
                              const SizedBox(
                                height: 15,
                              ),

                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonBar(
                                    children: [

                                      IconButton(
                                        onPressed: (){
                                          TextEditingController controller = TextEditingController(text: artMap['title']);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ModifierArticle(idArticle: document.id, titleArticle: artMap['title'], contentArticle: artMap['content'])));
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),

                                      IconButton(
                                        onPressed: (){
                                          TextEditingController controller = TextEditingController(text: artMap['title']);
                                          deleteArticle(context, articlesRef,  document.id);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),

                                      TextButton(
                                          onPressed: (){
                                            setState(() {
                                              voirDetail = !voirDetail;
                                              article = document;
                                            });
                                          },
                                          child: Text("Voir contenu",
                                            style: Theme.of(context).textTheme.headline3,
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Visibility(
                                  visible: voirDetail && article!.id == document.id,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        artMap["content"] != null ?
                                        Text(artMap["content"] ,
                                          textAlign: TextAlign.justify,
                                          style: Theme.of(context).textTheme.headline3,

                                        ): const Text(" "),
                                        //Text()
                                      ],
                                    ),
                                  )
                              ),
                              Container(
                                child: ElevatedButton(
                                    onPressed: (){
                                      articlesRef.doc(document.id).update({
                                        "isApproved": true,
                                        "datePosted": Timestamp.now(),
                                      }).then((value){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            duration: const Duration(seconds: 3),
                                            content: Text('Article Approuvé'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }).catchError((error) {
                                        // Afficher un message d'erreur avec ScaffoldMessenger
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            width: 20,
                                            duration:  Duration(seconds: 3),
                                            content: Text('Une erreur est survenue'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      });
                                    },
                                    child: const Text("Approuver")
                                ),
                              )

                            ],
                          ),
                      );
                    },


                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )
    );
  }


}
