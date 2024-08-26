import 'package:flutter/material.dart';
import 'package:your_project_name/models/bill.dart';
import 'package:your_project_name/widgets/bill_tile.dart';

class HomeScreen extends StatelessWidget {
  final List<Bill> bills = [
    Bill(title: 'Electricity Bill', amount: 100, dueDate: DateTime.now()),
    Bill(title: 'Internet Bill', amount: 50, dueDate: DateTime.now(), isJoint: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bill Tracker')),
      body: ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          return BillTile(bill: bills[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add bill screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
