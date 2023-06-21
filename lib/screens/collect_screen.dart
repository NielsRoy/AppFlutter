import 'package:flutter/material.dart';
import 'package:restservices/services/api_service.dart';

class CollectScreen extends StatefulWidget {
  @override
  _CollectScreenState createState() => _CollectScreenState();
}

class _CollectScreenState extends State<CollectScreen> {
  final TextEditingController _originAccountController = TextEditingController();
  final TextEditingController _destinationAccountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<dynamic>? accountOptions;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAccountOptions();
  }

  Future<void> _loadAccountOptions() async {
    try {
      List<dynamic> accounts = await ApiService.getCuentas(ApiService.userAuth);
      setState(() {
        accountOptions = accounts;
      });
    } catch (error) {
      // Manejar el error al cargar las opciones de cuenta
      //print('Error al cargar las cuentas: $error');
    }
  }

  Future<void> _updateAccountOptions() async {
    try {
      List<dynamic> accounts = await ApiService.getCuentas(ApiService.userAuth);
      setState(() {
        accountOptions = accounts;
      });
    } catch (error) {
      // Manejar el error al actualizar las opciones de cuenta
      //print('Error al actualizar las cuentas: $error');
    }
  }

  void _collectPayment() {
    String originAccountText = _originAccountController.text;
    //print('Cuenta de origen: $originAccountText');
    String originAccount = originAccountText.split(' ')[0];
    String amount = _amountController.text;
    String destinationAccount = _destinationAccountController.text;

    if (originAccountText.isNotEmpty && amount.isNotEmpty) {
      // Obtener el saldo y el número de cuenta de origen
      RegExp regex = RegExp(r'(\d+\.\d+)'); // Expresión regular para encontrar el saldo
      Iterable<Match> matches = regex.allMatches(originAccountText);
      if (matches.isNotEmpty) {
        Match match = matches.first;
        String accountBalance = match.group(0)!; // Obtener el saldo
        originAccountText = originAccountText.replaceAll(accountBalance, '').trim(); // Obtener el número de cuenta de origen

        double accountBalanceValue = double.tryParse(accountBalance) ?? 0.0;
        //print('Saldo de la cuenta: $accountBalanceValue');
        double paymentAmount = double.tryParse(amount) ?? 0.0;

        if (accountBalanceValue >= paymentAmount) {
          // Realizar la lógica de cobro o enviar la solicitud a la API
          ApiService.movimiento(destinationAccount, amount, originAccount);

          // Actualizar las opciones de cuenta con los nuevos saldos
          _updateAccountOptions();

          // Reiniciar los campos y mostrar un mensaje de éxito
          setState(() {
            _originAccountController.clear();
            _amountController.clear();
            _destinationAccountController.clear();
            errorMessage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Cobro realizado con éxito'),
          ));
        } else {
          setState(() {
            errorMessage = 'Saldo insuficiente';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Formato de cuenta de origen incorrecto';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cobro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: _originAccountController.text.isNotEmpty ? _originAccountController.text : null,
              items: accountOptions?.map<DropdownMenuItem<String>>((dynamic account) {
                String nro = account['nro'].toString();
                String saldo = account['saldo'].toString();
                String banco = account['banco'].toString();
                return DropdownMenuItem<String>(
                  value: '$nro - Saldo: $saldo - $banco', // Cambiado para incluir toda la opción
                  child: Text('$nro - Saldo: $saldo - $banco'),
                );
              }).toList(),
              onChanged: (String? selectedAccount) {
                setState(() {
                  _originAccountController.text = selectedAccount ?? '';
                  errorMessage = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Cuenta de destino',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monto',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _destinationAccountController,
              decoration: InputDecoration(
                labelText: 'Cuenta de origen',
              ),
            ),
            SizedBox(height: 24.0),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: _collectPayment,
              child: Text('Cobrar'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón "Generar QR"
                // Lógica para generar un código QR con la información de cobro
              },
              child: Text('Generar QR'),
            ),
          ],
        ),
      ),
    );
  }
}

