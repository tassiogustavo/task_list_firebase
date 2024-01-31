import 'package:flutter/material.dart';
import 'package:task_list_firebase/controllers/task_manager.dart';
import 'package:task_list_firebase/models/task.dart';
import 'package:task_list_firebase/utils/constants.dart';
import 'package:uuid/uuid.dart';

class DisplayDialogHelper {
  static TextEditingController titleController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();

  static TaskManager taskManager = TaskManager();

  static Future<void> displayInputTarefa(
      BuildContext context, bool isUpdate, List<Task> listTask,
      {int? index}) {
    Icon dropdownValue = listIcons.first;
    return showDialog(
      context: context,
      builder: (context) {
        if (isUpdate) {
          titleController.text = listTask[index!].title;
          descriptionController.text = listTask[index].description;
          dropdownValue = listIcons[listTask[index].priority];
        } else {
          titleController.clear();
          descriptionController.clear();
          dropdownValue = listIcons[0];
        }
        return AlertDialog(
          title: isUpdate
              ? const Text('Alterar Tarefa')
              : const Text('Nova Tarefa'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(hintText: "Titulo da tarefa"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(hintText: "Descricao da tarefa"),
                  ),
                  Row(
                    children: [
                      const Text("Prioridade: "),
                      DropdownButton<Icon>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        focusColor: Colors.transparent,
                        style: const TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (Icon? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            listIcons.map<DropdownMenuItem<Icon>>((Icon value) {
                          return DropdownMenuItem<Icon>(
                            value: value,
                            child: value,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            _buildMaterialButton(
                "CANCELAR", Colors.red, () => Navigator.pop(context)),
            _buildMaterialButton(
              "OK",
              Colors.green,
              () => _handleOkButtonPressed(
                  isUpdate, listTask, index, context, dropdownValue),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildMaterialButton(
      String label, Color color, VoidCallback onPressed) {
    return MaterialButton(
      color: color,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(label),
    );
  }

  static void _handleOkButtonPressed(
    bool isUpdate,
    List<Task> listTask,
    int? index,
    BuildContext context,
    Icon dropdownValue,
  ) {
    if (isUpdate && index != null) {
      Task task = listTask[index];
      task.id = listTask[index].id;
      task.title = titleController.text;
      task.description = descriptionController.text;
      task.priority = listIcons.indexOf(dropdownValue);

      taskManager.saveTask(task);
      Navigator.pop(context);
    } else {
      Task task = Task(
        id: const Uuid().v1(),
        title: titleController.text,
        description: descriptionController.text,
        isDone: false,
        priority: listIcons.indexOf(dropdownValue),
      );
      taskManager.saveTask(task);
      Navigator.pop(context);
    }
  }
}
