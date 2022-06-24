// So Basically this file contains the state of our app i.e., state == *A List*
import 'package:flutter/foundation.dart';
import 'package:todo/models/task.dart';
import 'dart:collection';


// ChangeNotifier class provides the notifyListeners() function 
// You can either use 'extends' or 'with' keyword
class TaskData extends ChangeNotifier{
  // This is the state that we're intending to provide to entire widget tree
  // so that it can be accessed at any level in the widget tree
  final List<Task> _tasks = [
    Task(name: 'Buy milk'),
    Task(name: 'Buy eggs'),
    Task(name: 'Buy bread'),
  ];
  // Since "_tasks" list is private, we're accessing the entire "_tasks" using pre-built "get" method
  UnmodifiableListView<Task> get tasks{
    return UnmodifiableListView(_tasks);
  }

  // Ref: https://www.geeksforgeeks.org/getter-and-setter-methods-in-dart/
  // Since "_tasks" list is private, we're accessing the length of the list using pre-built "get" method 
  int get taskCount{
    return _tasks.length;
  }

 // The parameter "newTaskTitle" arrives from the app. 
  void addTask(String newTaskTitle){
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    // This sort of re-renders the all the Widgets containing syntax "Provider.of<TextData>(context).[...]" 
    notifyListeners();
  }
 
  // we're going to get the variable 'task' of type *Task* from the app.
  void updateTask(Task task){
    task.toggleDone();
    // This sort of re-renders the all the Widgets containing syntax "Provider.of<TextData>(context).[...]" 
    notifyListeners();
  }

  void deleteTask(Task task){
    _tasks.remove(task);
    // This sort of re-renders the all the Widgets containing syntax "Provider.of<TextData>(context).[...]" 
    notifyListeners();
  }
}