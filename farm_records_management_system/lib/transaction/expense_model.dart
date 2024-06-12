class Expense {
  final int? expenseID;
  final double amount;
  final DateTime date;
  final String description;
  final int farmersID;

  Expense({
    this.expenseID,
    required this.amount,
    required this.date,
    required this.description,
    required this.farmersID,
  });

  Map<String, dynamic> toMap() {
    return {
      'expenseID': expenseID,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'farmersID': farmersID,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      expenseID: map['expenseID'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      farmersID: map['farmersID'],
    );
  }
}
