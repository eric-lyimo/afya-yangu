import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FamilyMember extends StatefulWidget {
  const FamilyMember({super.key});

  @override
  _AddFamilyMemberPageState createState() => _AddFamilyMemberPageState();
}

class _AddFamilyMemberPageState extends State<FamilyMember> {
  // List of existing family members (mock data for this example)
  List<Map<String, String>> existingFamilyMembers = [
    {'name': 'John Doe', 'relationship': 'Father'},
    {'name': 'Jane Doe', 'relationship': 'Mother'},
    {'name': 'Jake Doe', 'relationship': 'Son'},
  ];

  // Selected gender for the new family member
  String selectedGender = 'Male';

  // Date picker controller
  final TextEditingController _dobController = TextEditingController();

  // Function to open the bottom sheet for adding new family member
  void _showAddFamilyMemberSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height*0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),
          
                  // Profile Picture
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey[500],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Trigger photo picker
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
          
                  // Name Field
                  _buildTextField("Full Name", "Enter the member's full name"),
                  const SizedBox(height: 10),
          
                  // Relationship Field
                  _buildTextField("Relationship", "e.g., Son, Daughter, Spouse"),
          
                  const SizedBox(height: 10),
          
                  // Gender Selector
                  const Text("Gender", style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      _buildGenderButton(context, "Male"),
                      const SizedBox(width: 10),
                      _buildGenderButton(context, "Female"),
                      const SizedBox(width: 10),
                      _buildGenderButton(context, "Other"),
                    ],
                  ),
                  const SizedBox(height: 10),
          
                  // Date of Birth Field
                  _buildDateField("Date of Birth"),
          
                  const SizedBox(height: 20),
          
                  // Medical Details Section
                  const Text(
                    "Medical Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
          
                  _buildTextField("Blood Group", "e.g., A+, O-"),
                  const SizedBox(height: 10),
                  _buildTextField("Allergies", "Enter any known allergies"),
                  const SizedBox(height: 10),
                  _buildTextField("Pre-existing Conditions", "e.g., Diabetes, Asthma"),
                  const SizedBox(height: 10),
                  _buildTextField("Current Medications", "List any ongoing medications"),
                  const SizedBox(height: 20),
          
                  // Privileges Section
                  const Text(
                    "App Privileges",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    value: true,
                    onChanged: (bool value) {
                      // Handle switch
                    },
                    title: const Text("Enable Medication Reminders"),
                  ),
                  SwitchListTile(
                    value: true,
                    onChanged: (bool value) {
                      // Handle switch
                    },
                    title: const Text("Allow Access to Health Records"),
                  ),
          
                  const SizedBox(height: 30),
          
                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle save action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "Save Family Member",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to open the bottom sheet for editing family member
  void _showEditFamilyMemberSheet(Map<String, String> familyMember) {
    TextEditingController nameController = TextEditingController(text: familyMember['name']);
    TextEditingController relationshipController = TextEditingController(text: familyMember['relationship']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height*0.9,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title: Edit Family Member
                  const Text(
                    "Edit Family Member",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
          
                  // Name Field (Editable)
                  _buildTextField("Full Name", "Enter the member's full name", controller: nameController),
                  const SizedBox(height: 10),
          
                  // Relationship Field (Editable)
                  _buildTextField("Relationship", "e.g., Son, Daughter, Spouse", controller: relationshipController),
          
                  const SizedBox(height: 10),
          
                  // Gender Selector
                  const Text("Gender", style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      _buildGenderButton(context, "Male"),
                      const SizedBox(width: 10),
                      _buildGenderButton(context, "Female"),
                      const SizedBox(width: 10),
                      _buildGenderButton(context, "Other"),
                    ],
                  ),
                  const SizedBox(height: 10),
          
                  // Date of Birth Field
                  _buildDateField("Date of Birth"),
          
                  const SizedBox(height: 20),
          
                  // Save Changes Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Save updated information
                        setState(() {
                          familyMember['name'] = nameController.text;
                          familyMember['relationship'] = relationshipController.text;
                        });
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Existing Family Members Section
            const Text(
              "Existing Family Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display existing family members in cards
            if (existingFamilyMembers.isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: existingFamilyMembers.length,
                itemBuilder: (context, index) {
                  var member = existingFamilyMembers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: Text(member['name']!),
                      subtitle: Text(member['relationship']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditFamilyMemberSheet(member);
                        },
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              const Text("No family members added yet."),
            ],

            const SizedBox(height: 20),

            // Button to Add New Family Member
            Center(
              child: ElevatedButton(
                onPressed: _showAddFamilyMemberSheet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  "Add New Family Member",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
    );
  }

  // Helper: Text Field Builder with optional controller for pre-filled values
  Widget _buildTextField(
    String label,
    String hint, {
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Helper: Date Field
  Widget _buildDateField(String label) {
    return TextField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: label,
        hintText: "DD/MM/YYYY",
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          setState(() {
            _dobController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
          });
        }
      },
    );
  }

  // Helper: Gender Button Builder
  Widget _buildGenderButton(BuildContext context, String gender) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedGender = gender;
          });
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: selectedGender == gender
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        child: Text(gender),
      ),
    );
  }
}
