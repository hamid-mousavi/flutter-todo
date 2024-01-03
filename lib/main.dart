import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/database/HiveDataBase.dart';
import 'package:todo/data/repo/Repository.dart';
import 'package:todo/task.dart';
import 'package:todo/ui/screens/Home/bloc/task_list_bloc.dart';
import 'package:todo/ui/theme/themelight.dart';

import 'ui/screens/Home/my_home_page.dart';

const String boxName = "tasks";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PeriorityAdapter());
  final box = await Hive.openBox<TaskEntity>(boxName);
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
    create: (context) =>
        Repository<TaskEntity>(HiveDatabase(box: Hive.box(boxName))),
    child: const MyApp(),
  ));
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
      home: BlocProvider<TaskListBloc>(
          create: (context) =>
              TaskListBloc(context.read<Repository<TaskEntity>>()),
          child: const MyHomePage()),
    );
  }
}
