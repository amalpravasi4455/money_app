import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/money_provider.dart';
import '../screens/add_transaction_screen.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionDetail transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (isIncome ? Colors.green : Colors.red).withOpacity(0.2),
        child: Icon(
          isIncome ? Icons.trending_up : Icons.trending_down,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      title: Text(transaction.description ?? '---', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(DateFormat('dd MMM yyyy').format(transaction.date)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${isIncome ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => AddTransactionScreen(transactionToEdit: transaction)));
              } else if (value == 'delete') {
                 Provider.of<MoneyProvider>(context, listen: false).deleteTransaction(transaction.id!);
              }
            },
          ),
        ],
      ),
    );
  }
}
