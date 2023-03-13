import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderCatArticles extends StatefulWidget {
  String? category;
   HeaderCatArticles({Key? key, this.category}) : super(key: key);

  @override
  State<HeaderCatArticles> createState() => _HeaderCatArticlesState();
}

class _HeaderCatArticlesState extends State<HeaderCatArticles> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Stack(
      children: [

        Column(
          children:  [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top+25,
                  left: 25,
                  right: 25
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(widget.category!,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("Would you like to read?",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Text("Clique everywhere",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey,
                backgroundImage: NetworkImage(_user!.photoURL!,),
              ),

                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
            //ListFavoriteArticles(),
          ],
        ),

      ],
    );
  }
}
