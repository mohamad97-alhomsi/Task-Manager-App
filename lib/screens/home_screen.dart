import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:task_manager_app/business_logic/task_bloc/task_bloc.dart';
import 'package:task_manager_app/models/todo_model.dart';
import 'package:task_manager_app/widgets/task_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  int currentPage = 1;
  int totalTasks = 0;
  List<Todo> tasksList = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) =>
          TaskBloc()..add(FetchTaskEvent(skip: currentPage * 10)),
      child: Scaffold(
        drawer: const Drawer(
          width: 200,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Tasks"),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskErrorState) {
              Logger().e(state.error);
            }
            if (state is TaskSuccessState) {
              var tasks = state.taskModel;
              currentPage = tasks.skip!;
              totalTasks = tasks.total!;
              tasksList.addAll(tasks.todos!);
              return ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: (tasks.skip != totalTasks)
                    ? tasks.skip! + 1
                    : tasksList.length,
                itemBuilder: (context, index) {
                  if (index == (tasks.skip!) && currentPage < tasks.total!) {
                    return TextButton(
                        onPressed: () {
                          context
                              .read<TaskBloc>()
                              .add(FetchTaskEvent(skip: (currentPage + 10)));
                        },
                        child: Text("Load More"));
                  } else if (index == (tasks.skip!) &&
                      currentPage == tasks.total!) {
                    return Text("No More Data");
                  }
                  return TaskItem(
                    title: tasksList[index].todo ?? "",
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
