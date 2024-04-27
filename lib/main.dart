import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager_app/screens/home_screen.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/services/storage_service/storage_service.dart';

void main() async {
  await StorageService.getDatabase;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      
      builder: (_ , child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
        home: LoginScreen(),
        );
      }
    );
  }
}

