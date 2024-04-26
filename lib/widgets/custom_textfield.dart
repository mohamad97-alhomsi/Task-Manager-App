import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.prefixIcon,
      required this.hintText,
      this.isPassword = false,
      this.controller,
      this.keyboardType,

      this.validator});
  final IconData prefixIcon;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;


  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    // showPassword = widget.isPassword;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        controller: widget.controller,
        obscureText: showPassword,
        decoration: InputDecoration(
          
            contentPadding: EdgeInsets.zero,
          hintText: widget.hintText,

            prefixIcon: Icon(widget.prefixIcon),
             
            
    
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: const Color(0xffF6F6F6)
            
        ),
      ),
    );
  }
}
