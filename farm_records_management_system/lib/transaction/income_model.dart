class Transaction {
  final int? incomeID;
  final double amount;
  final DateTime date;
  final String description;

  Transaction({
    this.incomeID,
    required this.amount,
    required this.date,
    required this.description, 
    required int farmersID,
  });

  Map<String, dynamic> toMap() {
    return {
      'incomeID': incomeID,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      incomeID: map['incomeID'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'], 
      farmersID: map['farmersID'],
    );
  }
}
