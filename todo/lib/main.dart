import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task_data.dart';
import 'package:todo/screens/tasks_screen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
   // A wrapper that provides the state stored in task_data.dart
    return ChangeNotifierProvider(
      create: (_) => TaskData(),
      child:  MaterialApp(
        // Entry point to our app
        home:  TasksScreen(),
      )
    );
  }
}