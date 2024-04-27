import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(title),
      trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.cancel,
            color: Colors.red,
          )),
    );
  }
}
