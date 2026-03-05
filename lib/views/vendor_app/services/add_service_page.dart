
import 'package:connectme_app/views/vendor_app/services/service_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddServicePage extends ConsumerStatefulWidget {
  const AddServicePage({super.key});

  @override
  ConsumerState<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends ConsumerState<AddServicePage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: const Text('New Service')),
        body: ServiceForm()

    );
  }
}