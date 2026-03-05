import 'package:flutter/material.dart';




class ClientPersonalInformation extends StatefulWidget {
  const ClientPersonalInformation({super.key});

  @override
  State<ClientPersonalInformation> createState() => _ClientPersonalInformationState();
}

class _ClientPersonalInformationState extends State<ClientPersonalInformation> {

  // Field values
  String name = 'John Doe';
  String email = 'john.doe@example.com';
  String phone = '+1 (555) 555-5555';
  String address = '123 Main St, Anytown, USA';

  // Editing states
  Map<String, bool> isEditing = {
    'name': false,
    'email': false,
    'phone': false,
    'address': false,
  };

  // Controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
    addressController = TextEditingController(text: address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _buildEditableTile({
    required String label,
    required String fieldKey,
    required String value,
    required TextEditingController controller,
  }) {
    final editing = isEditing[fieldKey] ?? false;

    return ListTile(
      title: Text(label,
      style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: editing
          ? TextField(
          style: Theme.of(context).textTheme.bodySmall,
        controller: controller,
        autofocus: true,
        onSubmitted: (newValue) {
          setState(() {
            isEditing[fieldKey] = false;
            switch (fieldKey) {
              case 'name':
                name = newValue;
                break;
              case 'email':
                email = newValue;
                break;
              case 'phone':
                phone = newValue;
                break;
              case 'address':
                address = newValue;
                break;
            }
          });
        },
        onEditingComplete: () {
          setState(() => isEditing[fieldKey] = false);
        },
      )
          : Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () {
          setState(() {
            isEditing[fieldKey] = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        children: [
          _buildEditableTile(
            label: 'Name',
            fieldKey: 'name',
            value: name,
            controller: nameController,
          ),
          _buildEditableTile(
            label: 'Email',
            fieldKey: 'email',
            value: email,
            controller: emailController,
          ),
          _buildEditableTile(
            label: 'Phone Number',
            fieldKey: 'phone',
            value: phone,
            controller: phoneController,
          ),
          _buildEditableTile(
            label: 'Address',
            fieldKey: 'address',
            value: address,
            controller: addressController,
          ),
        ],
      ),
    );
  }
}
