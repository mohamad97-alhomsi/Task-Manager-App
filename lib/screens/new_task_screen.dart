import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:task_manager_app/business_logic/task_bloc/task_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/models/todo_model.dart';

class NewTaskScreen extends StatelessWidget {
  NewTaskScreen({super.key});

  final _textEditController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(),
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoadingState) {
            isLoading = true;
          }
          if (state is TaskErrorState) {
            isLoading = false;
            Logger().e(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is TaskSuccessState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Task Added successfully"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            blur: 1,
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Add Task"),
                actions: [
                  IconButton(
                      onPressed: () {
                        //? Add New Task
                        final todo =
                            Todo(todo: _textEditController.text, userId: 5);
                        context
                            .read<TaskBloc>()
                            .add(AddTaskEvent(todoModel: todo));
                      },
                      icon: const Icon(Icons.check)),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                    controller: _textEditController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    maxLines: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}
