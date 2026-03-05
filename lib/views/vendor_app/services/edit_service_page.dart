import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/views/vendor_app/services/service_input_form.dart';
import 'package:flutter/material.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({super.key,
  this.service
  });
  final ServiceOffered? service;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: const Text('Edit Service')),
        body: ServiceForm(service: widget.service)

    );
  }
}