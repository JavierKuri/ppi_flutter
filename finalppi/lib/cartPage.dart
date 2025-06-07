import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'catalogue.dart';
import 'globals.dart';
import 'package:finalppi/userPage.dart';
import 'package:finalppi/historyPage.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key, required this.title});
  final String title;

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {

  // For BottomNavBar
  int _selectedIndex = 1;
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

// Function for getting cart through PHP API
Future<List<Map<String, String>>> get_cart() async {
    final response = await http.post(
      Uri.parse('http://localhost:8001/get_cart.php'),
      body: {
        'id_usuario': id_usuario
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load cart');
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
        future: get_cart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cart found.'));
          } else {
            final games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length + 1,
              itemBuilder: (context, index) {
                if (index == games.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final response = await http.post(
                          Uri.parse('http://localhost:8001/payment.php'),
                          body: {
                            'id_usuario': id_usuario,
                          },
                        );
                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Transaction complete')),
                          );
                          setState(() {});
                        } else {
                          throw Exception('Failed to complete transaction');
                        }
                      },
                      child: const Text('Proceed to payment'),
                    ),
                  );
                }
                final game = games[index];
                return ListTile(
                  title: Text(game['titulo'] ?? 'Untitled'),
                  subtitle: Text('\$ ${game['precio']}'),
                  leading: Text(game['id_carrito']!),
                  trailing: ElevatedButton(onPressed: () async {
                    final response = await http.post(
                      Uri.parse('http://localhost:8001/delete_cart_item.php'),
                      body: {
                        'id_carrito':game['id_carrito']
                      },
                    );
                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item deleted from cart')),
                      );
                      setState(() {});
                    } else {
                      throw Exception('Failed to delete from cart');
                    }
                  }, 
                  child: const Text("Delete from cart"))
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