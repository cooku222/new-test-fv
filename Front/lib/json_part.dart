import 'package:flutter/material.dart';

class JsonPart extends StatefulWidget {
  const JsonPart({super.key});

  @override
  State<JsonPart> createState() => _JsonPartState();
}

class _JsonPartState extends State<JsonPart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('json test'),
      ),
    );
  }
}
