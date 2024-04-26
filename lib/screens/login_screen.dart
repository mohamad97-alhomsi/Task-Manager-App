import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:task_manager_app/business_logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager_app/models/user_model.dart';
import 'package:task_manager_app/widgets/custom_button.dart';
import 'package:task_manager_app/widgets/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            isLoading = true;
          }
          if (state is AuthErrorState) {
            isLoading = false;
            Logger().e("Error ${ state.stackTrace}",);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(state.error.toString()),backgroundColor: Colors.red,),);
          }
          if (state is AuthSuccessState) {
            isLoading =false;
            Logger().i(state.user.toJson());
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Login Successfully"),backgroundColor: Colors.green,),);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
              inAsyncCall: isLoading,
              blur: 1,
              child: Scaffold(
                drawer: Drawer(
                  width: 200.w,
                ),
                appBar: AppBar(
                  title: const Text("Login"),
                ),
                body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _textFieldTitleString(text: "User Name"),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h, top: 8.h),
                            child: CustomTextField(
                                prefixIcon: Icons.person,
                                controller: _userNameTextController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                hintText: "User Name"),
                          ),
                          _textFieldTitleString(text: "Password"),
                          Container(
                            margin: EdgeInsets.only(top: 8.h),
                            child: CustomTextField(
                                controller: _passwordTextController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                prefixIcon: Icons.lock,
                                hintText: "Password"),
                          ),

                          //? login button
                          Container(
                            margin: EdgeInsets.only(top: 20.h, bottom: 16.h),
                            child: CustomButton(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.blue,
                              text: "Login",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final _userData = UserModel(
                                      username: _userNameTextController.text,
                                      password: _passwordTextController.text);
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthLoginEvent(userData: _userData));
                                }
                              },
                              height: 48.h,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _textFieldTitleString({required String text}) {
    return Text(text);
  }
}
