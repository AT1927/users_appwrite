import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:users/controllers/user_controller.dart';
import 'package:users/model/user_model.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  HomePage({super.key});
  //----------------------------------------------------------------------------
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

  //----------------------------------------------------------------------------
  void _showEditDialog(
    BuildContext context,
    UserController controller,
    UserModel user,
  ) {
    final editUsernameController = TextEditingController(text: user.username);
    final editEmailController = TextEditingController(text: user.email);
    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Editar Usuario'),
            content: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editUsernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                    validator:
                        (value) => value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: editEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator:
                        (value) => value!.isEmpty ? 'Campo requerido' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (editFormKey.currentState!.validate()) {
                    final updatedUser = UserModel(
                      id: user.id,
                      username: editUsernameController.text,
                      email: editEmailController.text,
                    );
                    controller.updateUser(updatedUser);
                    Navigator.pop(context);
                  }
                },
                child: Text('Actualizar'),
              ),
            ],
          ),
    );
  }

  //----------------------------------------------------------------------------
  void _showDeleteDialog(
    BuildContext context,
    UserController controller,
    UserModel user,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Eliminar Usuario'),
            content: Text(
              '¿Está seguro que desea eliminar a ${user.username}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  controller.deleteUser(user.id);
                  Navigator.pop(context);
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios con Appwrite'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.find<UserController>().fetchUsers(),
          ),
        ],
      ),
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
                      SizedBox(height: 20), //Espacio superior con formulario
                      ElevatedButton(
                        onPressed: () => _submitUser(controller),
                        child: Text('Agregar Usuario'),
                      ),
                      SizedBox(height: 10), //Espacio inferior con listado bd
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
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(user.email),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed:
                                  () => _showEditDialog(
                                    context,
                                    controller,
                                    user,
                                  ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed:
                                  () => _showDeleteDialog(
                                    context,
                                    controller,
                                    user,
                                  ),
                            ),
                          ],
                        ),
                      ),
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
