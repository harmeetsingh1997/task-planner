
import 'package:task_planner/model/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {}

class TaskFailure extends TaskState {
  final String error;

  TaskFailure(this.error);
}
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}
class TaskDelete extends TaskState{

}