
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_planner/model/task_model.dart';

class FirebaseRepository {
  Future<void> addTask(Task task) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).set(task.toMap());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<List<Task>> fetchTask() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('tasks').get();
      return querySnapshot.docs.map((doc) {
        return Task.fromJson(doc.data()..['id'] = doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
  Future<void> updateTask(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }
}
