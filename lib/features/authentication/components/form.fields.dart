import 'package:flutter/material.dart';

// Reusable TextFormField Widget for text inputs, date picker, and dropdowns
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<String>? dropdownItems;
  final Function(String?)? onChanged;
  final bool isDatePicker;

  const CustomTextFormField({super.key, 
    required this.controller,
    required this.label,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.dropdownItems,
    this.onChanged,
    this.isDatePicker = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDatePicker) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format the date
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: validator,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                label: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2981b3),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (dropdownItems != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: DropdownButtonFormField<String>(
          value: controller.text.isEmpty ? null : controller.text,
          onChanged: onChanged,
          validator: validator,
          items: dropdownItems!
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          decoration: InputDecoration(
            label: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2981b3),
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            label: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2981b3),
              ),
            ),
          ),
        ),
      );
    }
  }
}
