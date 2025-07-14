import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/media_view_model.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MediaViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aspect Ratio App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
