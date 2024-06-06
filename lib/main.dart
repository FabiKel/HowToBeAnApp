import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/db/object_box.dart';
import 'package:htbah_app/db/provider.dart';

import 'app/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objBox = await ObjectBox.create();

  runApp(ProviderScope(
    overrides: [Prov.objBox.overrideWithValue(objBox)],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HowToBeAnApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
        ),
        useMaterial3: true,
      ),
      home: const Start(),
    );
  }
}
