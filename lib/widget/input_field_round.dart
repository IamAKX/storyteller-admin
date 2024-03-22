import 'package:flutter/material.dart';

class InputFieldRound extends StatelessWidget {
  const InputFieldRound(
      {Key? key,
      required this.hint,
      required this.controller,
      required this.keyboardType,
      required this.obscure,
      this.icon,
      this.enabled,
      this.onChange})
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final IconData? icon;

  final bool? enabled;
  final Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextField(
        cursorHeight: 10,
        enabled: enabled ?? true,
        keyboardType: keyboardType,
        autocorrect: true,
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          alignLabelWithHint: true,
          filled: false,
          contentPadding: const EdgeInsets.all(0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          prefixIcon: icon == null
              ? null
              : Icon(
                  icon,
                  size: 15,
                ),
        ),
        onChanged: onChange,
      ),
    );
  }
}
