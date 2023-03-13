import 'dart:io';
import 'package:blog_app/modele/utilisateur.dart';
import 'package:blog_app/screens/widget/mydrawer.dart';
import 'package:blog_app/screens/widget/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

import '../config/global.parents.dart';
import '../modele/carticles.dart';
import '../services/db_service.dart';



class AddArticlePage extends StatefulWidget {
  User user;

  AddArticlePage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddArticlePage> createState() => _TestAddPageState();
}

class _TestAddPageState extends State<AddArticlePage> {
  bool uploading = false;
  double val = 0;
  CollectionReference? articles;
  firebase_storage.Reference? ref;

  List<String> cats = ['Sports', 'Music', 'Politic'];

  final picker = ImagePicker();

  final articleValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(5, errorText: 'Content must be at least 200 digits long'),
  ]);

  final titleValidator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(5, errorText: 'Title must be at least 12 digits long'),
  ]);

  final imageNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Image name is required'),
  ]);

  void notifiedMessage(message){
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController articleController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController imageNameController = TextEditingController();

  String? _selected = "Sports";
  String? content;
  String? titre;
  String? imageName;
  final formkey = GlobalKey<FormState>();
  final String errorMessage = "Veuillez remplir tous les champs";

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool loading = false;
  bool isLoading = true;

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Color(0xFFF6F8FF),
        appBar: SimpleAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),

                 Text("Ajouter un article",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [

                        TextFormField(
                          minLines: 2,
                          maxLines: 2,
                          controller: titleController,
                          decoration: inputDecoration("Proposez un titre à votre articles"),
                          validator: titleValidator,

                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),

                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        TextFormField(
                          minLines: 3,
                          maxLines: 5,
                          controller: articleController,
                          decoration: inputDecoration("Le contenu de l'article", ),
                          validator: articleValidator,
                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),

                        ),


                        const SizedBox(
                          height: 15,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(

                                onPressed: selectFile,
                                child:  Text("Choisir une image",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                )
                                )
                            ),
                            IconButton(
                                onPressed: selectFile,
                                icon: const Icon(Icons.add)
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                if(pickedFile != null)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage((File(pickedFile!.path!)),)
                      ),
                       const SizedBox(
                         width: 8,
                       ),
                       Expanded(
                        child: TextFormField(
                          controller: imageNameController,
                          decoration: inputDecoration("Nom de l'image"),
                          validator: imageNameValidator,
                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),
                        )
                      ),

                    ],
                  ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     Text("Catégorie",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    DropdownButton(
                      hint:  Text(_selected!,
                          style: Theme.of(context).textTheme.headline2
                      ),
                      value: _selected,

                      onChanged: (newValue) {
                        setState(() {
                          _selected = newValue;
                        });
                      },
                      items: cats.map((categorie) {
                        return DropdownMenuItem(
                          value: categorie,
                          child: Text(categorie),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: const ButtonStyle(
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:  Text("Retour",
                          style: Theme.of(context).textTheme.headline1,
                        )
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        style: const ButtonStyle(
                        ),
                        onPressed: (){
                          if(formkey.currentState!.validate()){

                            try {

                              _displayDialog(context, _user!);

                            } catch (e) {
                              notifiedMessage("Une erreur s'est produite");
                            }

                          }

                        },
                        child:  Text("Publier",
                          style: Theme.of(context).textTheme.headline1,
                        )
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return null;

    setState(() {
      pickedFile = result.files.first;
    });
  }



  Future uploadFileData(User user) async {

    content = articleController.text;
    titre = titleController.text;

    if(pickedFile!=null) {
      final pathi = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filei = File(pickedFile!.path!);


      imageName = imageNameController.text;

      final ref = FirebaseStorage.instance.ref().child(pathi);
      setState(() {
        uploadTask = ref.putFile(filei);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

     final urlDownload = await snapshot.ref.getDownloadURL();

      Article articleImg = Article(
        id: articles?.doc().id,
        title: titre,
        content: content,
        imageUrl: urlDownload,
        category: _selected,
        userId: user.uid,
        datePosted: Timestamp.now(),
        likes: 0,
        likedBy: [],
        isApproved: false
      );

        await articles?.add(articleImg.toData()).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration:  Duration(seconds: 2),
            content: Text('Article Publié avec succès'),
          ),
        )).catchError((onError)=>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
        duration:  Duration(seconds: 4),
        content: Text('Une erreur s\'est produite'),
        ),
        )) ;
    }else {
      Article articleImg = Article(
        id: articles?.doc().id,
        title: titre,
        content: content,
        category: _selected,
        userId: user.uid,
        datePosted: Timestamp.now(),
        likes: 0,
        likedBy: [],
        isApproved: false
      );

      await articles?.add(articleImg.toDataWI()).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration:  Duration(seconds: 3),
          content: Text('Article Publié avec succès'),
        ),
      )).catchError((onError)=>
          // ignore: invalid_return_type_for_catch_error
          ScaffoldMessenger.of(context).showSnackBar(
           const  SnackBar(
              duration:  Duration(seconds: 4),
              content: Text('Une erreur s\'est produite'),
            ),
          )) ;
    }
    // setState(() {
    //   uploadTask = null;
    // });

  }



  _displayDialog(BuildContext context, User user) async {
    return showDialog(
        context: context,
        builder: (context){
          return Container(
            height: 200,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // content: const Text("Voulez-vous vraiment publier ce article ?"
              //     "Vous acceptez alors les conditions d'utilisattion"),
              actions: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                  ),
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Voulez-vous vraiment publier ce article ?"
                          "Vous acceptez alors les conditions d'utilisattion",
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          isLoading ? TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Annuler",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,

                                  fontWeight: FontWeight.bold

                              ),
                            ),
                          ):Container(),
                          TextButton(
                            onPressed: (){
                              addUser(context, user);
                              uploadFileData(widget.user);
                              notifiedMessage("Chargement...");

                              setState(() {
                                pickedFile == null;
                                titleController.text = "";
                                articleController.text = "";
                                imageNameController.text = "";
                              });
                              Navigator.pop(context);
                              // uploadFilet(widget.user).whenComplete(() => Navigator.of(context).pushNamed("/controlPage"));
                            },
                            child: const Text("Accepter",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,

                                  fontWeight: FontWeight.bold

                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    articles = FirebaseFirestore.instance.collection("articles");
  }
}
