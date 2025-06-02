import 'package:flutter/material.dart';

class catalogue extends StatefulWidget {
  const catalogue({super.key, required this.title});
  final String title;

  @override
  State<catalogue> createState() => _catalogueState();
}

class _catalogueState extends State<catalogue> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
    );
  }
}