import 'package:blog_app/screens/widget/botton_navigation_bar.dart';
import 'package:blog_app/screens/widget/const_entete.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/testapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import 'detail_article.dart';
import 'modifier_article.dart';

class MesArticles extends StatefulWidget {
  @override
  _MesArticles createState() => _MesArticles();
}

class _MesArticles extends State<MesArticles> {

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

      appBar: CustomAppBar(
        image: 'images/musicback.png',
        height: MediaQuery.of(context).size.height*0.25,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(
              height: 25,
            ),

            EnteteListArticle(user: _user,section: "Vos articles"),
            StreamBuilder(
              stream: articlesRef
                  .orderBy('datePosted', descending: true)
                  .where('userId', isEqualTo: _user!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return  Center(
                      child: Text(
                      'Une erreur s\'est produite',
                    style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                    ),
                  ));
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
                        child: TextButton(
                            onPressed: (){},
                            child: Text("Aucun article trouvé\n"
                                "Cliiquez ici pour ajouter",
                              style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold
                              ),

                                )),
                      );
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                    ),
                      color: Colors.white.withOpacity(0.4),
                      margin: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailArticle(artid: document.id)));
                        },
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
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w500
                           )
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Statut: ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                               artMap["isApproved"] == true ?  Row(
                                 children: [
                                   Text("Approuvé",
                                        style: GoogleFonts.poppins(
                                            color: Colors.green,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500
                                        )
                                    ),
                                   const Icon(Icons.check, size: 35, color: Colors.green,)
                                 ],
                               ):
                               Row(
                                 children: [
                                   Text("Non Approuvé",
                                       style: GoogleFonts.poppins(
                                           color: Colors.deepOrangeAccent,
                                           fontSize: 26,
                                           fontWeight: FontWeight.w500
                                       )
                                   ),
                                   const Icon(Icons.close, size: 35, color: Colors.deepOrangeAccent,)
                                 ],
                               )
                              ],
                            )

                          ],
                        ),
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
