class Expenses {
  final int id;
  final double amount;
  final String expenseName;
  final String date;
  final String description;

  const Expenses(
      {required this.amount,
      required this.expenseName,
      required this.date,
      required this.description,
      required this.id});

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
        id: json['id'],
        amount: json['amount'],
        expenseName: json['expenseName'],
        date: json['date'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'expenseName': expenseName,
        'date': date,
        'description': description,
      };
}
