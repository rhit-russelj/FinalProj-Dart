import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:my_photo_bucket/pages/video_bucket_list_page.dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Exam 2: Jessica Russell

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
        "223577861571-viuacsnq02s69fs8dkptgo3o4p5q1a5r.apps.googleusercontent.com"),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Bucket with Text-to-Speech',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const VideoBucketListPage(),
    );
  }
}