import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class catalogue extends StatefulWidget {
  const catalogue({super.key, required this.title});
  final String title;

  @override
  State<catalogue> createState() => _catalogueState();
}

class _catalogueState extends State<catalogue> {

  Future<List<Map<String, String>>> get_games() async {
    final response = await http.get(
      Uri.parse('http://localhost:8001/get_games.php')
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: get_games(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No games found.'));
          } else {
            final games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return ListTile(
                  title: Text(game['titulo'] ?? 'Untitled'),
                  subtitle: Text('\$ ${game['precio']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}