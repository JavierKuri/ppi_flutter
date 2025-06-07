import 'package:finalppi/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class signupPage extends StatefulWidget {
  const signupPage({super.key, required this.title});
  final String title;

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _birthdayController = TextEditingController();
final TextEditingController _addressController = TextEditingController();

Future<void> signup() async {
    final response = await http.post(
      Uri.parse('http://localhost:8001/create_user.php'),
      body: {
        'nombre': _nameController.text,
        'correo': _emailController.text,
        'contra': _passwordController.text,
        'fecha_nacimiento': _birthdayController.text,
        'direccion': _addressController.text
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Navigate to HomeScreen on success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup succesful. Returning to login page...')),
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(title: "Login")),
          );
        });
      } else {
        // Show login failed message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      // Server or network error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server error. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Fields for user input
      body: ListView(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email"
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password"
            ),
          ),
          TextField(
            controller: _birthdayController,
            decoration: InputDecoration(
              labelText: "Birthday"
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: "Address"
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: signup, child: const Text("Submit"))
        ],
      )
    );
  }
}