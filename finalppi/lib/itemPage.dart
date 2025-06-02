import 'package:flutter/material.dart';
import 'dart:convert';

class itemPage extends StatefulWidget {
  final Map<String, String> game;
  const itemPage({super.key, required this.game});

  @override
  State<itemPage> createState() => _itemPageState();
}

class _itemPageState extends State<itemPage> {
  @override
  Widget build(BuildContext context) {
    final game = widget.game;

    return Scaffold(
      appBar: AppBar(title: Text(game['titulo'] ?? 'Game')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              game['portada'] != null
                  ? Image.memory(base64Decode(game['portada']!))
                  : const Icon(Icons.image_not_supported, size: 100),
              const SizedBox(height: 16),
              Text('Price: \$${game['precio']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Description: ${game['descripcion'] ?? 'No description'}'),
              const SizedBox(height: 8),
              Text('Developer: ${game['desarrollador'] ?? 'No developer'}'),
              const SizedBox(height: 8),
              Text('ESRB: ${game['ESRB'] ?? 'No ESRB'}'),
            ],
          ),
        ),
      ),
    );
  }
}
