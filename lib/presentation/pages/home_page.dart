import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:users/controllers/user_controller.dart';
import 'package:users/model/user_model.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  HomePage({super.key});

  void _submitUser(UserController controller) {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        id: '',
        username: _usernameController.text,
        email: _emailController.text,
      );

      controller.addUser(user);

      _usernameController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuarios con Appwrite')),
      body: GetX<UserController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      ElevatedButton(
                        onPressed: () => _submitUser(controller),
                        child: Text('Agregar Usuario'),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.error.value.isNotEmpty)
                Text(
                  'Error: ${controller.error.value}',
                  style: TextStyle(color: Colors.red),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
