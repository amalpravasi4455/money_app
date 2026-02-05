import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';
import '../models/book.dart';

class BooksManagementScreen extends StatelessWidget {
  const BooksManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Books')),
      body: Consumer<MoneyProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.books.length,
            itemBuilder: (context, index) {
              final book = provider.books[index];
              final isSelected = provider.currentBook?.id == book.id;
                return ListTile(
                  leading: CircleAvatar(backgroundColor: Color(book.colorValue)),
                  title: Text(book.name),
                  subtitle: Text(
                    book.lastUpdated != null 
                        ? 'Updated: ${_formatDate(book.lastUpdated!)}' 
                        : 'No updates yet',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditBookDialog(context, book);
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(context, book);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    provider.switchBook(book);
                    Navigator.pop(context);
                  },
                );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBookDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Book'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Book Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<MoneyProvider>(context, listen: false).addBook(
                  controller.text, 
                  Colors.primaries[controller.text.length % Colors.primaries.length].value
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }


  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  void _showEditBookDialog(BuildContext context, Book book) {
    final controller = TextEditingController(text: book.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Book'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Book Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<MoneyProvider>(context, listen: false).updateBook(
                  book.id!,
                  controller.text, 
                  book.colorValue
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.name}"? All transactions in this book will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Provider.of<MoneyProvider>(context, listen: false).deleteBook(book.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
