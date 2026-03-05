import 'package:flutter/material.dart';


class TestRoute extends StatefulWidget {
  const TestRoute({super.key});

  @override
  State<TestRoute> createState() => _TestRouteState();
}

class _TestRouteState extends State<TestRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Text("This is a test route")),
    );
  }
}
