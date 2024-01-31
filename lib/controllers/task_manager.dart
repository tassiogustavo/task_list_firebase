import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_list_firebase/models/task.dart';

class TaskManager {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Task>> getTasks() async {
    List<Task> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('tasks').get();
    for (var doc in snapshot.docs) {
      temp.add(Task.fromMap(doc.data()));
    }
    return temp;
  }

  saveTask(Task task) {
    firestore.collection('tasks').doc(task.id).set(task.toMap());
  }

  finishTask(Task task) {
    if (task.isDone) {
      task.isDone = false;
    } else {
      task.isDone = true;
    }
    saveTask(task);
  }

  deleteTask(Task task) {
    firestore.collection('tasks').doc(task.id).delete();
  }
}
