import 'package:flutter/material.dart';
import 'package:font_bugz/dialogs/google_font_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Too buggy',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// ==============================================

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => showFontDialog(context: context),
        child: Text('Open Font Dialog'),
      ),
    );
  }
}
