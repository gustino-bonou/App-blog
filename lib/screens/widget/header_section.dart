import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/authentification.dart';
import '../../services/db_service.dart';
import '../appove_article.dart';
import '../authentification/login_by_google.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {

  bool _isSuperUser = false;

  int _docLength = 0;


  @override
  void initState() {
    // TODO: implement initState

    // countUnapprovedArticles().then((value){
    //   setState(() {
    //     _docLength = value;
    //   });
    // });

    isSuperUser().then((value) {
      setState(() {
        _isSuperUser = value;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top+25,
        left: 25,
        right: 25
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
             const  Text("Welcome, ",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text("Would you like to read ?",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),

              _isSuperUser ?
                  Row(
                    children:  [

                      TextButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>const ApproveArticle()));
                          },
                          child:  StreamBuilder<int>(
                            stream: streamUnapprovedArticleCount(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Une erreur est survenue');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...');
                              }
                              int unapprovedCount = snapshot.data ?? 0;
                              return Text('Articles non Approuvés: $unapprovedCount',
                                style: const TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                              );
                            },
                          ),
                      )


                    ],
                  ):const  Text(""),

            ],
          ),
          CircleAvatar(
            child:  IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context)=>const Login()));
                AuthService().signOut();
              },
            ),
          )
        ],
      ),
    );
  }
}
