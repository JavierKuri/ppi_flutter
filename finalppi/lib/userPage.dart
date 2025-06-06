import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finalppi/historyPage.dart';
import 'catalogue.dart';
import 'globals.dart';
import 'package:finalppi/cartPage.dart';

class userPage extends StatefulWidget {
  const userPage({super.key, required this.title});
  final String title;

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {

  // For BottomNavBar
  int _selectedIndex = 3;
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

    }
  }

// Function for getting user data through PHP API
Future<Map<String, String>> get_user() async {
    final response = await http.post(
      Uri.parse('http://localhost:8001/get_user.php'),
      body: {
        'id_usuario': id_usuario
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception('Failed to load user data');
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
      body: FutureBuilder<Map<String, String>>(
        future: get_user(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No user data found.'));
          } else {
            final user = snapshot.data!;
            return Center(
              child: ListView(
                children: [
                  Text("Name: ${user['nombre']}"),
                  const SizedBox(height: 16),
                  Text("E-Mail: ${user['correo']}"),
                  const SizedBox(height: 16),
                  Text("Date of Birth: ${user['fecha_nacimiento']}"),
                  const SizedBox(height: 16),
                  Text("Address: ${user['direccion']}")
                ],
              ),
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