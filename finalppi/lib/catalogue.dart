import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finalppi/historyPage.dart';
import 'itemPage.dart';
import 'package:finalppi/userPage.dart';
import 'package:finalppi/cartPage.dart';

class catalogue extends StatefulWidget {
  const catalogue({super.key, required this.title});
  final String title;

  @override
  State<catalogue> createState() => _catalogueState();
}

class _catalogueState extends State<catalogue> {

  // For BottomNavBar
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation
    if (index == 0) {
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => cartPage(title: 'Cart')),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => historyPage(title: 'History')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => userPage(title: 'User')),
      );
    }
  }
  
  // For search bar
  final TextEditingController _searchBarController = TextEditingController();

  // Function for getting games through PHP API
  late Future<List<Map<String, String>>> _gamesFuture;
  Future<List<Map<String, String>>> get_games([String busqueda = '']) async {
    final response = await http.get(
      Uri.parse('http://localhost:8001/get_games.php?busqueda=${Uri.encodeComponent(busqueda)}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  //For preloading data
  @override
  void initState() {
    super.initState();
    _gamesFuture = get_games();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // Get and show games
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchBarController,
              hintText: 'Search games...',
              leading: const Icon(Icons.search),
              onChanged: (busqueda) {
                setState(() {
                  _gamesFuture = get_games(busqueda.trim());
                });
              },
            ),
          ),
          Expanded( 
            child: FutureBuilder<List<Map<String, String>>>(
              future: _gamesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No games found.'));
                } else {
                  final games = snapshot.data!;
                  return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return ListTile(
                        title: Text(game['titulo'] ?? 'Untitled'),
                        subtitle: Text('\$ ${game['precio']}'),
                        leading: game['portada'] != null
                            ? Image.memory(base64Decode(game['portada']!))
                            : const Icon(Icons.image_not_supported),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => itemPage(game: game)),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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