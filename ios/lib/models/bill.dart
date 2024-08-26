class Bill {
  String name;
  double amount;
  DateTime dueDate;
  bool isPaid;

  Bill({required this.name, required this.amount, required this.dueDate, this.isPaid = false});
}
