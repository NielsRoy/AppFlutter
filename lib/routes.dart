import 'package:flutter/material.dart';
import 'package:restservices/screens/collect_screen.dart';
import 'package:restservices/screens/login_screen.dart';
import 'package:restservices/screens/home_screen.dart';
import 'package:restservices/screens/payment_screen.dart';
import 'package:restservices/screens/transaction_history_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  '/payment': (context) => PaymentScreen(),
  '/collect': (context) => CollectScreen(),
  '/transaction-history': (context) => TransactionHistoryScreen(),
};
