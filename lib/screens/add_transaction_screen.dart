import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionDetail? transactionToEdit;

  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TransactionType _type = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      _descriptionController.text = widget.transactionToEdit!.description ?? '';
      _amountController.text = widget.transactionToEdit!.amount.toString();
      _selectedDate = widget.transactionToEdit!.date;
      _type = widget.transactionToEdit!.type;
    }
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitData() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<MoneyProvider>(context, listen: false);
    final enteredDescription = _descriptionController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (provider.currentBook == null) return;

    if (widget.transactionToEdit != null) {
      provider.updateTransaction(TransactionDetail(
        id: widget.transactionToEdit!.id,
        amount: enteredAmount,
        description: enteredDescription.isEmpty ? null : enteredDescription,
        date: _selectedDate,
        type: _type,
        bookId: provider.currentBook!.id!,
      ));
    } else {
      provider.addTransaction(TransactionDetail(
        amount: enteredAmount,
        description: enteredDescription.isEmpty ? null : enteredDescription,
        date: _selectedDate,
        type: _type,
        bookId: provider.currentBook!.id!,
      ));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.transactionToEdit == null ? 'Add Transaction' : 'Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(value: TransactionType.income, label: Text('Income'), icon: Icon(Icons.arrow_upward)),
                  ButtonSegment(value: TransactionType.expense, label: Text('Expense'), icon: Icon(Icons.arrow_downward)),
                ],
                selected: {_type},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) => null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder(), prefixText: '₹ '),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _presentDatePicker,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: _type == TransactionType.income ? Colors.green.shade800 : Colors.red.shade800,
                  foregroundColor: Colors.white,
                ),
                child: Text(widget.transactionToEdit == null ? 'Save Transaction' : 'Update Transaction', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
