enum TransactionType { income, expense }

class TransactionDetail {
  final int? id;
  final double amount;
  final String? description;
  final DateTime date;
  final TransactionType type;
  final int bookId;

  TransactionDetail({
    this.id,
    required this.amount,
    this.description,
    required this.date,
    required this.type,
    required this.bookId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'type': type == TransactionType.income ? 'income' : 'expense',
      'bookId': bookId,
    };
  }

  factory TransactionDetail.fromMap(Map<String, dynamic> map) {
    return TransactionDetail(
      id: map['id'],
      amount: map['amount'].toDouble(),
      description: map['description'],
      date: DateTime.parse(map['date']),
      type: map['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      bookId: map['bookId'],
    );
  }
}
