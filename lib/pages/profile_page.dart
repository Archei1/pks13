import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pks11/pages/login_page.dart';

import '../services/auth_service.dart';
import 'orders_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  final TextEditingController _nameController =
  TextEditingController(text: 'Рабкин Артур');
  final TextEditingController _emailController =
  TextEditingController(text: 'artur.rabkin@example.com');
  final TextEditingController _phoneController =
  TextEditingController(text: '+7 123 456-78-90');
  final TextEditingController _avatarUrlController = TextEditingController(
      text:
      'https://avatars.dzeninfra.ru/get-zen_doc/1875939/pub_5d0694d862f9700db603f9b7_5d069802353a0c0d81786116/scale_1200');

  final _formKey = GlobalKey<FormState>();

  final authService = AuthService();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль сохранен')),
      );
    }
  }

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  void logout() async {
    await authService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;
    if (_isValidUrl(_avatarUrlController.text)) {
      avatarImage = NetworkImage(_avatarUrlController.text);
    } else {
      avatarImage = const AssetImage('assets/default_avatar.png');
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          backgroundColor: Colors.blueGrey,
          actions: [
            _isEditing
                ? IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            )
                : IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editProfile,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isEditing ? () {} : null,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: avatarImage,
                      backgroundColor: Colors.grey[200],
                      child: _isEditing
                          ? const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, color: Colors.black),
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя и фамилия',
                      prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите имя и фамилию';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      prefixIcon: Icon(Icons.phone, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите номер телефона';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag, color: Colors.white),
                    label: const Text(
                      'Мои заказы',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidUrl(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      return false;
    }
    return true;
  }
}

