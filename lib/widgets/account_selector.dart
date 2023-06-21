import 'package:flutter/material.dart';
import 'package:restservices/services/api_service.dart';

class AccountSelector extends StatefulWidget {
  final String userId;
  final Function(String) onAccountSelected;

  AccountSelector({
    required this.userId,
    required this.onAccountSelected,
  });

  @override
  _AccountSelectorState createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  Future<List<dynamic>>? cuentasFuture;
  String selectedAccount = '';

  @override
  void initState() {
    super.initState();
    cuentasFuture = ApiService.getCuentas(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: cuentasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostrar un indicador de carga mientras se obtienen los datos
        } else if (snapshot.hasError) {
          return Text('Error al cargar las cuentas'); // Mostrar un mensaje de error si ocurre algún problema
        } else {
          final cuentas = snapshot.data;
          return DropdownButton<String>(
            value: selectedAccount,
            onChanged: (String? newValue) {
              setState(() {
                selectedAccount = newValue!;
                widget.onAccountSelected(selectedAccount);
              });
            },
            items: cuentas?.map<DropdownMenuItem<String>>((dynamic cuenta) {
              final nro = cuenta['nro'];
              final saldo = cuenta['saldo'];
              final banco = cuenta['banco'];
              final displayText = '$nro - $saldo - $banco';
              return DropdownMenuItem<String>(
                value: displayText,
                child: Text(displayText),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
