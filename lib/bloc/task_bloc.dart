
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/bloc/task_event.dart';
import 'package:task_planner/bloc/task_state.dart';
import 'package:task_planner/repository/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FirebaseRepository firebaseRepository;

  TaskBloc({required this.firebaseRepository}) : super(TaskInitial()) {
    on<AddTaskEvent>(_onAddTask);
    on<FetchTask>(_onFetchTasks);
    on<DeleteTask>(_onDeleteTasks);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await firebaseRepository.addTask(event.task);
      final tasks = await firebaseRepository.fetchTask();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
  Future<void> _onFetchTasks(FetchTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await firebaseRepository.fetchTask();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskFailure('Failed to load tasks: $e'));
    }
  }
  Future<void> _onDeleteTasks(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await firebaseRepository.deleteTask(event.taskId);
      final tasks = await firebaseRepository.fetchTask();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await firebaseRepository.updateTask(event.task);
      final tasks = await firebaseRepository.fetchTask();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

}
