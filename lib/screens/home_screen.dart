import 'package:flutter/material.dart';
import 'package:restservices/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService(); // Instancia del servicio API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ButtonTheme(
            minWidth: 200.0, // Ancho mínimo de los botones
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Pagar"
                    Navigator.pushNamed(context, '/payment');
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)), // Tamaño mínimo del botón
                  ),
                  child: Text('Pagar'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Cobrar"
                    Navigator.pushNamed(context, '/collect');
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)), // Tamaño mínimo del botón
                  ),
                  child: Text('Cobrar'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Ver movimientos"
                    Navigator.pushNamed(context, '/transaction-history');
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)), // Tamaño mínimo del botón
                  ),
                  child: Text('Ver movimientos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

