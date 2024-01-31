import 'package:flutter/material.dart';
import 'package:task_list_firebase/controllers/task_manager.dart';
import 'package:task_list_firebase/models/task.dart';
import 'package:task_list_firebase/utils/constants.dart';
import 'package:task_list_firebase/utils/display_dialog_helper.dart';
import 'package:task_list_firebase/utils/modal_bottom_sheet_tarefas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskManager taskManager = TaskManager();
  List<Task> tasks = [];

  Future<void> updateList() async {
    tasks = await taskManager.getTasks();

    setState(() {
      tasks;
    });
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Tarefas"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => updateList(),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListTile(
                title: Text(
                  tasks[index].title,
                  style: TextStyle(
                    fontSize: 20,
                    decoration:
                        tasks[index].isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  tasks[index].description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    decoration:
                        tasks[index].isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: listIcons[tasks[index].priority].color,
                ),
              ),
              onTap: () async {
                await ModalBottomSheetTarefas.modalBottomSheetTarefas(
                    context, tasks, index);
                updateList();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DisplayDialogHelper.displayInputTarefa(context, false, tasks);
          updateList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
