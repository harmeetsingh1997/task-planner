import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/bloc/task_bloc.dart';
import 'package:task_planner/bloc/task_event.dart';
import 'package:task_planner/bloc/task_state.dart';
import 'package:task_planner/presentation/screens/create_task.dart';
import 'package:intl/intl.dart';
import '../../model/task_model.dart';

class TaskPlannerHomePage extends StatefulWidget {
  const TaskPlannerHomePage({super.key});

  @override
  State<TaskPlannerHomePage> createState() => _TaskPlannerHomePageState();
}

class _TaskPlannerHomePageState extends State<TaskPlannerHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTask());
  }

  void _editTaskDialog(BuildContext context, Task task) {
    final TextEditingController taskController = TextEditingController(text: task.task);
    final TextEditingController descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(labelText: 'Task'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedTask = Task(
                  id: task.id,
                  task: taskController.text,
                  description: descriptionController.text,
                  date: task.date,
                  time: task.time,
                  isChecked: task.isChecked,
                );
                context.read<TaskBloc>().add(UpdateTask(updatedTask));

                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('What\'s New Today?'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Text(
                  'Today is : ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                  style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height * 0.01),

              Expanded(child: _buildTaskList(context)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              String formattedDate = DateFormat('dd-MM-yyyy ').format(task.date);
              String formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(task.time);

              return Card(
                elevation: 5,
                shadowColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Row(
                    children: [
                      const Icon(Icons.task, color: Colors.blue),
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.task,
                              style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: size.height * 0.005),
                            Text(
                              task.description,
                              style: TextStyle(fontSize: size.width * 0.035),
                            ),
                            Text(formattedDate),
                            Text(formattedTime),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: task.isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            task.isChecked = value ?? false;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editTaskDialog(context, task);
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(DeleteTask(task.id));
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is TaskFailure) {
          return Center(child: Text('Data failed: ${state.error}'));
        } else {
          return const Center(child: Text('Failed'));
        }
      },
    );
  }
}
