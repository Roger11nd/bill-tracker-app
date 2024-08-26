import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill Tracker & Checkbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BillCheckbookHome(),
    );
  }
}

class BillCheckbookHome extends StatefulWidget {
  @override
  _BillCheckbookHomeState createState() => _BillCheckbookHomeState();
}

class _BillCheckbookHomeState extends State<BillCheckbookHome> {
  List<Bill> bills = [];
  List<CheckbookEntry> checkbook = [];
  double currentBalance = 0.0;

  void addBill(String name, double amount, DateTime dueDate) {
    setState(() {
      bills.add(Bill(name: name, amount: amount, dueDate: dueDate));
    });
  }

  void addPurchase(String name, double amount) {
    setState(() {
      currentBalance -= amount;
      checkbook.add(CheckbookEntry(name: name, amount: -amount, date: DateTime.now()));
    });
  }

  void addDeposit(String name, double amount) {
    setState(() {
      currentBalance += amount;
      checkbook.add(CheckbookEntry(name: name, amount: amount, date: DateTime.now()));
    });
  }

  void togglePaidStatus(int index) {
    setState(() {
      if (!bills[index].isPaid) {
        currentBalance -= bills[index].amount;
      } else {
        currentBalance += bills[index].amount;
      }
      bills[index].isPaid = !bills[index].isPaid;
    });
  }
