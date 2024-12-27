import 'package:flutter/material.dart';

class ContactInformationPage extends StatefulWidget {
  const ContactInformationPage({super.key});

  @override
  _ContactInformationPageState createState() =>
      _ContactInformationPageState();
}

class _ContactInformationPageState extends State<ContactInformationPage> {
  List<Map<String, String>> contactDetails = [
    {'type': 'Phone', 'value': '+1 234 567 890'},
    {'type': 'Email', 'value': 'example@email.com'},
  ];

  List<Map<String, String>> addresses = [
    {'type': 'Home', 'value': '123 Main St, Springfield'},
    {'type': 'Office', 'value': '456 Elm St, Shelbyville'},
  ];

  // Function to show modal for adding/editing contact details
  void _showAddEditContactModal({Map<String, String>? existingContact}) {
    TextEditingController typeController = TextEditingController(
      text: existingContact?['type'] ?? '',
    );
    TextEditingController valueController = TextEditingController(
      text: existingContact?['value'] ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existingContact == null ? "Add Contact Detail" : "Edit Contact Detail",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: "Type",
                  hintText: "e.g., Phone, Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: "Value",
                  hintText: "e.g., +1 234 567 890, example@email.com",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (existingContact != null) {
                      existingContact['type'] = typeController.text;
                      existingContact['value'] = valueController.text;
                    } else {
                      contactDetails.add({
                        'type': typeController.text,
                        'value': valueController.text,
                      });
                    }
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(existingContact == null ? "Add" : "Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show modal for adding/editing addresses
  void _showAddEditAddressModal({Map<String, String>? existingAddress}) {
    TextEditingController typeController = TextEditingController(
      text: existingAddress?['type'] ?? '',
    );
    TextEditingController valueController = TextEditingController(
      text: existingAddress?['value'] ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existingAddress == null ? "Add Address" : "Edit Address",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: "Type",
                  hintText: "e.g., Home, Office",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  hintText: "Enter full address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (existingAddress != null) {
                      existingAddress['type'] = typeController.text;
                      existingAddress['value'] = valueController.text;
                    } else {
                      addresses.add({
                        'type': typeController.text,
                        'value': valueController.text,
                      });
                    }
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(existingAddress == null ? "Add" : "Save"),
              ),
            ],
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
            // Contact Details Section
            const Text(
              "Contact Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...contactDetails.map((contact) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(contact['type']!),
                  subtitle: Text(contact['value']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showAddEditContactModal(
                          existingContact: contact,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            contactDetails.remove(contact);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            ElevatedButton(
              onPressed: () => _showAddEditContactModal(),
              child: const Text("Add Contact Detail"),
            ),
            const SizedBox(height: 20),

            // Home Address Section
            const Text(
              "Home Addresses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...addresses.map((address) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(address['type']!),
                  subtitle: Text(address['value']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showAddEditAddressModal(
                          existingAddress: address,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            addresses.remove(address);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            ElevatedButton(
              onPressed: () => _showAddEditAddressModal(),
              child: const Text("Add Address"),
            ),
          ],
        ),
    );
  }
}
