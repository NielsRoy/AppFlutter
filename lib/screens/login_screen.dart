import 'package:flutter/material.dart';
import 'package:restservices/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                try {
                  String? token = await ApiService.login(username, password);
                  if (token != null) {
                    // Autenticación exitosa, navegar a la siguiente pantalla
                    Navigator.pushNamed(context, '/home');
                  } else {
                    // Mostrar mensaje de error de autenticación
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error de autenticación'),
                        content: Text('Credenciales incorrectas'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error de conexión'),
                      content: Text('No se pudo conectar al servidor'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

