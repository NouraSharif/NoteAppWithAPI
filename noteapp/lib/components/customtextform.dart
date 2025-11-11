import 'package:flutter/material.dart';

class CustTextFormSign extends StatelessWidget {
  final String hint;
  final TextEditingController mycontroller;
  final String? Function(String?) valid;
  final TextInputType? textInputType;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustTextFormSign({
    Key? key,
    required this.hint,
    required this.mycontroller,
    required this.valid,
    this.textInputType,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        keyboardType: textInputType,
        obscureText: obscureText,
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
