import 'package:flutter/material.dart';

class AuthenticationTextFormField extends StatelessWidget {
  const AuthenticationTextFormField({
    this.confirmationController,
    required this.icon,
    required this.label,
    required this.textEditingController,
    super.key,
  });

  final TextEditingController? confirmationController;
  final IconData icon;
  final String label;
  final TextEditingController textEditingController;

  String? _validate(String? value) {
    if (value!.isEmpty) {
      return 'This field cannot be empty.';
    }

    if (key.toString().contains('email') == true &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) == false) {
      return 'This is not a valid email address.';
    }

    if (key.toString().contains('password') == true && value.length < 6) {
      return 'The password must be at least 6 characters.';
    }

    if (key.toString().contains('password_confirmation') == true &&
        value != confirmationController?.text) {
      return 'The password does not match.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Container(
decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.2), // Shadow color
        blurRadius: 20, // How much the shadow is blurred
        offset: const Offset(4, 4), 
      ),
    ],
  ),
  child: 
    TextFormField(
      controller: textEditingController,
      obscureText: label.toLowerCase().contains('password'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        
          enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),

    ),


      ),
      validator: _validate,
    )
    );
  }
}