import 'package:flutter/material.dart';






class StripeRefreshUrlPage extends StatefulWidget {
  const StripeRefreshUrlPage({super.key});

  @override
  State<StripeRefreshUrlPage> createState() => _StripeRefreshUrlPageState();
}

class _StripeRefreshUrlPageState extends State<StripeRefreshUrlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Setup"),),
      body: Center(child:Text("Something went wrong, please try again later")),
    );
  }
}
