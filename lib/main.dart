import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/task.dart';
import 'package:todo/ui/theme/themelight.dart';

import 'ui/screens/Home/my_home_page.dart';

const String boxName = "tasks";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PeriorityAdapter());
  final box = await Hive.openBox<TaskEntity>(boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(),
        colorScheme: ColorScheme.light(
          background: LightTheme.backgroundColor,
          secondary: LightTheme.secondaryColor,
          surface: LightTheme.primaryColor,
          onSurface: LightTheme.textColor,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
