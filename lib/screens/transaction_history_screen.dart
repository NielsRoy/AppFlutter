import 'package:flutter/material.dart';
import 'package:restservices/services/api_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final ApiService apiService = ApiService(); // Instancia de ApiService
  String? selectedAccount;
  List<dynamic>? accountMovements;

  @override
  Widget build(BuildContext context) {
    // Implementar la pantalla de historial de transacciones
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de transacciones'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ComboBox para seleccionar la cuenta
            FutureBuilder<List<dynamic>>(
              future: ApiService.getCuentas(ApiService.userAuth), // Llamada al método getCuentas
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
                } else if (snapshot.hasError) {
                  return Text('Error al cargar las cuentas'); // Muestra un mensaje de error si ocurre un error en la llamada
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay cuentas disponibles'); // Muestra un mensaje si no hay datos disponibles
                } else {
                  List<String> cuentaOptions = snapshot.data!.map<String>((cuenta) {
                    String nro = cuenta['nro'].toString();
                    String saldo = cuenta['saldo'].toString();
                    String banco = cuenta['banco'].toString();
                    return '$nro - Saldo: $saldo - $banco';
                  }).toList();

                  return DropdownButton<String>(
                    value: selectedAccount, // Valor inicial seleccionado
                    hint: Text('Seleccionar cuenta'), // Valor por defecto
                    isExpanded: true, // Hace que el ComboBox ocupe todo el ancho disponible
                    onChanged: (String? newValue) async {
                      setState(() {
                        selectedAccount = newValue;
                        accountMovements = null; // Reiniciar la lista de movimientos
                      });

                      if (newValue != null) {
                        String selectedNro = newValue.split(' ')[0]; // Extraer el primer valor numérico
                        List<dynamic> movements = await ApiService.getMovimientos(selectedNro);
                        setState(() {
                          accountMovements = movements;
                        });
                      }

                      print('Seleccionaste: $newValue');
                    },
                    items: cuentaOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            // Mostrar los movimientos de la cuenta seleccionada
            if (accountMovements != null)
              Column(
                children: accountMovements!.map<Widget>((movement) {
                  String tipo = movement['tipo'].toString();
                  String monto = movement['monto'].toString();
                  String destino = movement['destino'].toString();
                  String origen = movement['origen'].toString();
                  String fecha = movement['fecha'].toString();
                  return ListTile(
                    title: Text('Tipo: $tipo'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monto: $monto'),
                        if (destino != "null")
                          Text('Destino: $destino'),
                        if (origen != "null")
                          Text('Origen: $origen'),  
                        Text('Fecha: $fecha'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            // Aquí se pueden agregar los demás elementos de la pantalla de historial de transacciones
          ],
        ),
      ),
    );
  }
}






