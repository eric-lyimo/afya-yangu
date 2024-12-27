import 'package:flutter/material.dart';

class AddVitalSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onAdd; // Optional callback for saving data

  const AddVitalSheet({super.key, this.onAdd});

  @override
  _AddVitalSheetState createState() => _AddVitalSheetState();
}

class _AddVitalSheetState extends State<AddVitalSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _vitalName;
  String? _reading;
  TimeOfDay? _selectedTime;

  /// Picks a time using [showTimePicker] and updates the state.
  void _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  /// Validates and saves the form, then sends the data back to the parent (if callback exists).
  void _saveVital() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final formattedTime = _selectedTime != null
          ? _selectedTime!.format(context)
          : TimeOfDay.now().format(context);

      final vitalData = {
        "name": _vitalName!,
        "reading": _reading!,
        "time": formattedTime,
      };

      // If a callback is provided, invoke it
      widget.onAdd?.call(vitalData);

      // Close the bottom sheet
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Vital",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Vital Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a vital name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _vitalName = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Reading (e.g., 120/80 mmHg)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a reading";
                  }
                  return null;
                },
                onSaved: (value) {
                  _reading = value;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    _selectedTime == null
                        ? "Select Time"
                        : "Time: ${_selectedTime!.format(context)}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _pickTime(context),
                    child: const Text("Pick Time"),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVital,
                  child: const Text("Save Vital"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
