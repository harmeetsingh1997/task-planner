import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/bloc/task_bloc.dart';
import 'package:task_planner/bloc/task_event.dart';
import 'package:task_planner/presentation/screens/home_page.dart';
import 'package:task_planner/repository/task_repository.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
  );
  runApp(const TaskPlannerApp());
}
    class TaskPlannerApp extends StatefulWidget {
     const TaskPlannerApp({super.key});
      @override
      State<TaskPlannerApp> createState() => _TaskPlannerAppState();
    }
   class _TaskPlannerAppState extends State<TaskPlannerApp> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
            TaskBloc(firebaseRepository: FirebaseRepository())..add(FetchTask())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Planner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        home: const TaskPlannerHomePage(),
      ),
    );
  }
}
