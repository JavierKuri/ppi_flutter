import 'package:flutter/material.dart';
import 'dart:convert';
import 'globals.dart';
import 'package:http/http.dart' as http;

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
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () async {
                final response = await http.post(
                Uri.parse('http://localhost:8001/update_cart.php'),
                body: {
                  'id_usuario': id_usuario,
                  'id_juego': game['id_juego']
                },
              );
              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item added to cart')),
                );
              } else {
                throw Exception('Failed to add item');
              }
              }, 
              child: const Text("Add to cart"))
            ],
          ),
        ),
      ),
    );
  }
}
