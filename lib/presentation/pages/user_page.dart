import 'package:flutter/material.dart';
import 'package:users/model/user_model.dart';

class UserPage extends StatelessWidget {
  final UserModel user;

  const UserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Usuario'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Información del Usuario',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Username'),
                  subtitle: Text(user.username),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: Icon(Icons.key),
                  title: Text('ID'),
                  subtitle: Text(user.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
