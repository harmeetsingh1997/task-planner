
import 'package:task_planner/model/task_model.dart';

abstract class TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent({ required this.task});
}
class FetchTask extends TaskEvent{}

class DeleteTask extends TaskEvent{

  final String taskId;

  DeleteTask(this.taskId);
}
class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);
}

