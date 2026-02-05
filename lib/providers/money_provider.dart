import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class MoneyProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<Book> _books = [];
  List<TransactionDetail> _transactions = [];
  Book? _currentBook;

  List<Book> get books => _books;
  List<TransactionDetail> get transactions => _transactions;
  Book? get currentBook => _currentBook;

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> init() async {
    _books = await _dbService.getBooks();
    if (_books.isNotEmpty) {
      _currentBook = _books.first;
      await fetchTransactions();
    }
    notifyListeners();
  }

  Future<void> switchBook(Book book) async {
    _currentBook = book;
    await fetchTransactions();
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    if (_currentBook != null) {
      _transactions = await _dbService.getTransactionsByBook(_currentBook!.id!);
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionDetail transaction) async {
    await _dbService.insertTransaction(transaction);
    await fetchTransactions();
  }

  Future<void> addBook(String name, int colorValue) async {
    final newBook = Book(
      name: name, 
      colorValue: colorValue,
      lastUpdated: DateTime.now(),
    );
    await _dbService.insertBook(newBook);
    _books = await _dbService.getBooks();
    notifyListeners();
  }

  Future<void> updateBook(int id, String name, int colorValue) async {
    final updatedBook = Book(
      id: id,
      name: name,
      colorValue: colorValue,
      lastUpdated: DateTime.now(),
    );
    await _dbService.updateBook(updatedBook);
    _books = await _dbService.getBooks();
    if (_currentBook?.id == id) {
      _currentBook = updatedBook;
    }
    notifyListeners();
  }

  Future<void> deleteBook(int id) async {
    await _dbService.deleteBook(id);
    _books = await _dbService.getBooks();
    if (_currentBook?.id == id) {
      _currentBook = _books.isNotEmpty ? _books.first : null;
      await fetchTransactions(); 
    }
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionDetail transaction) async {
    await _dbService.updateTransaction(transaction);
    await fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _dbService.deleteTransaction(id);
    await fetchTransactions();
  }

  // Monthly and Weekly Reports logic can be added here
  Map<String, double> getMonthlyOverview() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    
    final currentMonthTransactions = _transactions.where((t) => t.date.isAfter(firstDayOfMonth.subtract(const Duration(seconds: 1))));
    
    double income = 0;
    double expense = 0;
    
    for (var t in currentMonthTransactions) {
      if (t.type == TransactionType.income) income += t.amount;
      else expense += t.amount;
    }
    
    return {'income': income, 'expense': expense};
  }
}
