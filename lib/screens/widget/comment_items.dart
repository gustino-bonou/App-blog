import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../modele/commentaire.modele.dart';
import '../../services/db_service.dart';
import '../../util/show_snackbar.dart';
import 'dialogModified.dart';
import '../../util/format_date.dart';

class BuildCommentsItems extends StatefulWidget {

  BuildContext context;
  Comment comment;
  CollectionReference collectionReference;
  String? articleID;
  BuildCommentsItems({Key? key, required this.context, required this.comment, required this.collectionReference, this.articleID}) : super(key: key);


  @override
  State<BuildCommentsItems> createState() => _BuildCommentsItemsState();
}

class _BuildCommentsItemsState extends State<BuildCommentsItems> {

  bool isFavorite = false;
  bool _isSuperUser = false;

  @override
  void initState() {
    // TODO: implement initState
    isSuperUser().then((value) {
      setState(() {
        _isSuperUser = value;
      });
    }) ;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    final _user = Provider.of<User?>(context);
    TextEditingController contentController = TextEditingController(text: widget.comment.content);
    String date = formateDate(widget.comment.datePosted!);
    Map commMap = widget.comment.toData() ;
    return Padding(
        padding: const EdgeInsets.only(right: 5, left: 5),
        child: Card(

            child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commMap["imageUrl"] != null ?
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(commMap["imageUrl"]),
                      ):Container(),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(commMap["content"],
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500
                              ),
                              //textAlign: TextAlign.justify,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(date,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold

                                  ),
                                ),
                                // ((commMap["userId"] == _user!.uid) || _isSuperUser) ?
                                // IconButton(
                                //     onPressed: (){
                                //       showDialogModifyComment(context, contentController, widget.collectionReference, widget.comment.id!, );
                                //     },
                                //     icon:  Icon(Icons.edit, color: Colors.deepOrangeAccent.withOpacity(0.7),),
                                // ):Container(),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          _likeComment(context, widget.collectionReference, widget.comment, _user.uid);
                                          isFavorite = !isFavorite;
                                        },
                                        icon:  Icon(Icons.thumb_up_outlined,
                                          color: widget.comment.likedBy!.contains(_user!.uid)
                                              ? Colors.red
                                              : Colors.grey.shade700,
                                        )
                                    ),
                                    Text("${commMap["likes"]}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold

                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // _isSuperUser ? Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     IconButton(
                            //         onPressed: (){
                            //           showDialogModifyComment(context, contentController, widget.collectionReference, widget.comment.id!, );
                            //         },
                            //         icon: const Icon(Icons.edit, size: 35, color: Colors.deepOrangeAccent,),
                            //     ),
                            //     IconButton(
                            //       onPressed: (){
                            //         deleteCooment(context, widget.articleID!, widget.comment.id!);
                            //       },
                            //       icon: const Icon(Icons.delete, size: 35, color: Colors.deepOrangeAccent,),
                            //     ),
                            //
                            //   ],
                            // ): const Text(""),
                          ],
                        ),
                      ),
                      (_isSuperUser || (commMap["userId"] == _user.uid)) ? PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Supprimer"),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Modifier"),
                            ),
                            const PopupMenuItem(
                              value: 3,
                              child: Text("retour"),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == 1) {
                            deleteCooment(context, widget.articleID!, widget.comment.id!);
                          } else if (value == 2) {
                            showDialogModifyComment(context, contentController, widget.collectionReference, widget.comment.id!, );
                          } else if (value == 3) {
                            //_voir();
                          }
                        },
                      ): const Text(""),
                    ],
                  ),

                ]
            )
        )
    );
  }
}




Widget buildCommentItem(BuildContext context, Comment comment, CollectionReference collectionReference) {
  final _user = Provider.of<User?>(context);
  TextEditingController contentController = TextEditingController(text: comment.content);
  String date = formateDate(comment.datePosted!);
  Map commMap = comment.toData() ;
  bool isFavorite = false;
  return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commMap["imageUrl"] != null ?
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(commMap["imageUrl"]),
                    ):Container(),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(commMap["content"],
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500
                            ),
                            //textAlign: TextAlign.justify,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(date,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold

                                ),
                              ),
                              commMap["userId"] == _user!.uid ?
                              TextButton(
                                  onPressed: (){
                                    showDialogModifyComment(context, contentController, collectionReference, comment.id!, );
                                  },
                                  child: const Text("Modifier",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ):Container(),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        _likeComment(context, collectionReference, comment, _user.uid);
                                        isFavorite = !isFavorite;
                                      },
                                      icon:  Icon(Icons.favorite_outline,
                                        color: comment.likedBy!.contains(_user.uid)
                                            ? Colors.red
                                            : Colors.grey.shade700,
                                      )
                                  ),
                                  Text("${commMap["likes"]}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
          )
      )
  );
}



//
// Widget buildCommentItem(BuildContext context, Comment comment, CollectionReference collectionReference) {
//   final _user = Provider.of<User?>(context);
//   TextEditingController contentController = TextEditingController(text: comment.content);
//   String date = formateDate(comment.datePosted!);
//   Map commMap = comment.toData() ;
//   bool isFavorite = false;
//   return Padding(
//       padding: const EdgeInsets.only(right: 5, left: 5),
//       child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//               children: [
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     commMap["imageUrl"] != null ?
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: NetworkImage(commMap["imageUrl"]),
//                     ):Container(),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(commMap["content"],
//                                 style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w500
//                           ),
//                                 //textAlign: TextAlign.justify,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(date,
//                                     style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold
//
//                                     ),
//                                   ),
//                                   commMap["userId"] == _user!.uid ?
//                                       TextButton(
//                                           onPressed: (){
//                                             showMyDialog(context, contentController, collectionReference, comment.id!, );
//                                           },
//                                           child: const Text("Modifier",
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold
//                                           ),
//                                           )
//                                       ):Container(),
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                           onPressed: (){
//                                             _likeComment(context, collectionReference, comment, _user.uid);
//                                             isFavorite = !isFavorite;
//                                           },
//                                           icon:  Icon(Icons.favorite_outline,
//                                             color: comment.likedBy!.contains(_user.uid)
//                                                 ? Colors.red
//                                                 : Colors.grey.shade700,
//                                           )
//                                       ),
//                                       Text("${commMap["likes"]}",
//                                         style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold
//
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                   ],
//                 ),
//               ]
//           )
//       )
//   );
// }
Future<void> _likeComment(BuildContext context,CollectionReference collection, Comment comment, currentUserId) async {
  final articleRef = collection.doc(comment.id);
  articleRef.get().then((doc) {
    final article = Comment.fromDocument(doc);
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