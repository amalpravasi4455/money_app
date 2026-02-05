import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Reports')),
      body: Consumer<MoneyProvider>(
        builder: (context, provider, child) {
          final monthly = provider.getMonthlyOverview();
          final income = monthly['income'] ?? 0;
          final expense = monthly['expense'] ?? 0;
          final total = income + expense;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Monthly Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: total == 0 
                    ? const Center(child: Text('No data for this month'))
                    : PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.greenAccent,
                              value: income,
                              title: 'Income',
                              radius: 50,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            PieChartSectionData(
                              color: Colors.redAccent,
                              value: expense,
                              title: 'Expense',
                              radius: 50,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                ),
                const SizedBox(height: 40),
                _buildReportRow('Total Income', income, Colors.greenAccent),
                const Divider(),
                _buildReportRow('Total Expense', expense, Colors.redAccent),
                const Divider(),
                _buildReportRow('Net Savings', income - expense, Colors.blueAccent),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
