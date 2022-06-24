import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task_data.dart';
import 'package:todo/widgets/task_tile.dart';


class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Consumer<TaskData>(builder: (context, taskData, child){return ...} is replacement for "Provider.of<TaskData>(context)")
    // And is used when you need to use "Provider.of<TaskData>(context)" frequently in the same class or widget
    return Consumer<TaskData>(
      builder: (context, taskData, child){
      // This is the syntax for rendering a dynamic ListViewer in Flutter that gets updated when we add/delete items in the list
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            // Builds TaskTile for each index in the List
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkBoxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              longPressCallback: (){
                taskData.deleteTask(task);
              },
            );
           },
           itemCount: taskData.taskCount,
          );
      },
    );
  }
}