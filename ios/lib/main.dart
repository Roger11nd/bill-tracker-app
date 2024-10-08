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

  void showAddBillDialog() {
    String name = '';
    double amount = 0.0;
    DateTime dueDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Bill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Bill Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                onChanged: (value) {
                  dueDate = DateTime.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addBill(name, amount, dueDate);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showAddPurchaseDialog() {
    String name = '';
    double amount = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Purchase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Purchase Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addPurchase(name, amount);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showAddDepositDialog() {
    String name = '';
    double amount = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Deposit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Deposit Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addDeposit(name, amount);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Tracker & Checkbook'),
      ),
      body: Container(
        color: currentBalance < 0 ? Colors.red.shade100 : Colors.white,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance: \$${currentBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: currentBalance < 0 ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Bills',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  Bill bill = bills[index];
                  return Card(
                    color: bill.isPaid ? Colors.green.shade100 : Colors.white,
                    child: ListTile(
                      title: Text(bill.name),
                      subtitle: Text(
                          'Amount: \$${bill.amount.toStringAsFixed(2)} | Due: ${bill.dueDate.toString().split(' ')[0]}'),
                      trailing: Checkbox(
                        value: bill.isPaid,
                        onChanged: (value) {
                          togglePaidStatus(index);
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Checkbook',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: checkbook.length,
                itemBuilder: (context, index) {
                  CheckbookEntry entry = checkbook[index];
                  return ListTile(
                    title: Text(entry.name),
                    subtitle: Text(
                        'Amount: \$${entry.amount.toStringAsFixed(2)} | Date: ${entry.date.toString().split(' ')[0]}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'addBill',
            onPressed: showAddBillDialog,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: 'addPurchase',
            onPressed: showAddPurchaseDialog,
            child: Icon(Icons.shopping_cart),
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: 'addDeposit',
            onPressed: showAddDepositDialog,
            child: Icon(Icons.attach_money),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class Bill {
  String name;
  double amount;
  DateTime dueDate;
  bool isPaid;

  Bill({required this.name, required this.amount, required this.dueDate, this.isPaid = false});
}

class CheckbookEntry {
  String name;
  double amount;
  DateTime date;

  CheckbookEntry({required this.name, required this.amount, required this.date});
}
