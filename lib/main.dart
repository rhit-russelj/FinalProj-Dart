// import 'package:counting_game/MovieQuotes/lib/pages/movieQuotesListPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS Department Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MovieQuoteListPage(),
    );
  }
}