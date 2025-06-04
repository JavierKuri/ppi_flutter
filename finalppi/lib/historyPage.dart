import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'catalogue.dart';

class historyPage extends StatefulWidget {
  const historyPage({super.key, required this.title});
  final String title;

  @override
  State<historyPage> createState() => _historyPageState();
}

class _historyPageState extends State<historyPage> {

  // For BottomNavBar
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => catalogue(title: 'Catalogue')),
      );
    } else if (index == 1) {
    } else if (index == 2) {
    }
  }

// Function for getting history through PHP API
Future<List<Map<String, String>>> get_history() async {
    final response = await http.get(
      Uri.parse('http://localhost:8001/get_history.php')
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Get and Show games in ListView
      body: FutureBuilder<List<Map<String, String>>>(
        future: get_history(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history found.'));
          } else {
            final games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return ListTile(
                  title: Text(game['titulo'] ?? 'Untitled'),
                  subtitle: Text('\$ ${game['precio']}'),
                  leading: Text(game['id_compra']!)
                );
              },
            );
          }
        },
      ),

      // Bottom Nav Bar
     bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}