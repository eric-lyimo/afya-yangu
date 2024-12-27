import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final title = TextEditingController();
  final gender = TextEditingController();
  String dob = '';
  late TextEditingController _dobController;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _titles = ['Mr', 'Mrs', 'Ms', 'Dr', 'Prof'];

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(text: dob);
  }

  @override
  void dispose() {
    fullName.dispose();
    phone.dispose();
    email.dispose();
    title.dispose();
    gender.dispose();
    _dobController.dispose();
    super.dispose();
  }

  _saveChanges(Users user) async {
    if (_formKey.currentState!.validate()) {
      // Assuming updateUserProfile returns a response with success and message keys
      Map<String, dynamic> resp = await DatabaseHelper().updateUserProfile(context: context, user: user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserProvider>().user;

    if (user != null) {
      fullName.text = user.name;
      phone.text = user.phone;
      email.text = user.email;
      gender.text = user.gender;
      title.text = user.title;
      dob = user.dob;
      _dobController.text = dob;
    }

    return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                final file = result.files.first;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Selected file: ${file.name}')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const FaIcon(FontAwesomeIcons.upload),
                            label: const Text('Upload Image'),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Format: PNG/JPG/JPEG • Max Size: 1MB',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: fullName,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person,
                validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
              ),
              _buildDateField(
                label: 'Date of Birth',
                hint: 'Select your birth date',
                icon: FontAwesomeIcons.calendarDay,
                controller: _dobController,
              ),
              _buildTextField(
                controller: email,
                label: 'Email',
                hint: 'Enter your email',
                icon: FontAwesomeIcons.envelope,
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              _buildDropdownField(
                label: 'Gender',
                icon: FontAwesomeIcons.personHalfDress,
                items: _genders,
                value: gender.text,
                onChanged: (value) => setState(() => gender.text = value!),
              ),
              _buildDropdownField(
                label: 'Title',
                icon: FontAwesomeIcons.userTie,
                items: _titles,
                value: title.text,
                onChanged: (value) => setState(() => title.text = value!),
              ),
              _buildTextField(
                controller: phone,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                icon: FontAwesomeIcons.phone,
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    label: 'Cancel',
                    color: Colors.grey,
                    onPressed: () => Navigator.pop(context),
                  ),
                  _buildActionButton(
                    label: 'Save',
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Users updated = Users(
                        email: email.text,
                        phone: phone.text,
                        name: fullName.text,
                        dob: dob,
                        gender: gender.text,
                        title: title.text,
                        userId: user!.userId, 
                        password: user.password,
                      );
                      _saveChanges(updated);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FormFieldValidator<String> validator,
    String? initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColorDark),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColorDark),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onTap: _pickDate,
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dob = '${pickedDate.toLocal()}'.split(' ')[0];
        _dobController.text = dob;
      });
    }
  }

Widget _buildDropdownField({
  required String label,
  required IconData icon,
  required List<String> items,
  required String? value,
  required ValueChanged<String?> onChanged,
}) {
  // If the value is null or empty, use the first item from the list as the default value
  String selectedValue = value?.isNotEmpty ?? false ? value! : items[0];

  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColorDark),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      value: selectedValue, // Set the default value to the selectedValue
      onChanged: onChanged,
      validator: (value) => value == null || value.isEmpty ? 'Please select your $label' : null,
    ),
  );
}


  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
