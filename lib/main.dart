import 'package:blog_app/screens/add_article.dart';
import 'package:blog_app/screens/authentification/login_by_email.dart';
import 'package:blog_app/screens/carticles.dart';
import 'package:blog_app/screens/mes_article.dart';
import 'package:blog_app/screens/mes_favoris.dart';
import 'package:blog_app/screens/rechercer_article.dart';
import 'package:blog_app/screens/sport.dart';
import 'package:blog_app/services/authentification.dart';
import 'package:blog_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/global.parents.dart';
import 'screens/authentification/login_by_google.dart';

final d_green =  Color(0xFFF6F8FF);

//const d_green = Color(0xFFE97170);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options:
  );
  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     print('Handling a background message: ${message.notification}');
  //   }
  //
  // }


  //comporte de l'appli en quand il y a une notif en arrire plan, (-firebaseMessage...
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channel.description,
  //             icon: 'ic_launcher',
  //           ),
  //         ));
  //   }
  // });



  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[250],
        textTheme: textTheme(),
        // iconTheme: IconThemeData(
        //   color: Colors.red,
        // ),
      ),

      routes: {
        "/": (context) => const Wrapper(),
        "/home": (context) => HomePage(),
        "/addArticle": (context) => AddArticlePage(user: user!),
        "/inscrire": (context) => const Login(),
        "/controlPage": (context) => SportArticle(),
        "/mesarticles": (context) => MesArticles(),
        "/favorite": (context) => MesFavoris(),
        "/rechercher": (context) => RechercheArticle(""),
        "/write": (context) => AddArticlePage(user: user!),
        "/emaillogin": (context) => EmailLogin(),
      },
      initialRoute: "/",
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();
//
//     if (firebaseUser != null) {
//       return HomePage();
//     }
//     return const Login();
//   }
// }
