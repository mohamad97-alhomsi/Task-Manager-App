import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:task_manager_app/business_logic/task_bloc/task_bloc.dart';
import 'package:task_manager_app/models/todo_model.dart';
import 'package:task_manager_app/screens/new_task_screen.dart';
import 'package:task_manager_app/screens/update_task_screen.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.todoModel});
  final Todo todoModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateTaskScreen(todoModel: todoModel)));
      },
      title: Text(todoModel.todo ?? ""),
      trailing: IconButton(
          onPressed: () {
            context
                .read<TaskBloc>()
                .add(DeleteTaskEvent(taskId: todoModel.id!));
          },
          icon: BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.error.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
                Logger().e(state.error);
              }
              if (state is TaskSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content:
                        Text("Simulate Delete Method on dummyJson server "),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is TaskLoadingState) {
                return const SizedBox(
                    width: 25, height: 25, child: CircularProgressIndicator());
              }
              return const Icon(
                Icons.cancel,
                color: Colors.red,
              );
            },
          )),
    );
  }
}
