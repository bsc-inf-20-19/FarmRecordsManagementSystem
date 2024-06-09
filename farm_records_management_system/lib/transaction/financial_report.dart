import 'package:farm_records_management_system/project_trial/farmer_DAO.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/project_trial/database_helper.dart';
import 'package:farm_records_management_system/project_trial/farmer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'summary_screen.dart';

class FinancialReportManagement extends StatefulWidget {
  final int farmerID;

  FinancialReportManagement({required this.farmerID});

  @override
  _FinancialReportManagementState createState() => _FinancialReportManagementState();
}

class _FinancialReportManagementState extends State<FinancialReportManagement> {
  late Future<Map<String, dynamic>> _report;

  @override
  void initState() {
    super.initState();
    _report = generateFarmerReport(widget.farmerID);
  }

  Future<Map<String, dynamic>> generateFarmerReport(int farmerID) async {
    Farmer? farmer = await FarmerDAO.instance.getFarmer(farmerID);
    if (farmer == null) {
      throw Exception('Farmer not found');
    }

    Map<String, dynamic> financialReport = await DatabaseHelper.instance.getFinancialReport(farmerID);

    return {
      'farmer': farmer, 
      'financialReport': financialReport,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Management'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _report,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> report = snapshot.data!;
            Farmer farmer = report['farmer'];
            Map<String, dynamic> financialReport = report['financialReport'];

          return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('Farmer: ${farmer.firstName} ${farmer.lastName}'),
                        subtitle: Text('Email: ${farmer.email}'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Financial Report:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Card(
                      child: ListTile(
                        title: Text('Total Income'),
                        trailing: Text('${financialReport['totalIncome']}', style: TextStyle(color: Colors.green)),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Total Expense'),
                        trailing: Text('${financialReport['totalExpense']}', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Net Income'),
                        trailing: Text('${financialReport['netIncome']}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: PieChart(PieChartData(sections: _createIncomeExpenseData(financialReport))),
                    ),
                    SizedBox(height: 20),
                    _buildLegend(),
                    SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        title: Text('Summary'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(farmerID: widget.farmerID),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<PieChartSectionData> _createIncomeExpenseData(Map<String, dynamic> financialReport) {
    double totalIncome = financialReport['totalIncome']?.toDouble() ?? 0.0;
    double totalExpense = financialReport['totalExpense']?.toDouble() ?? 0.0;

    return [
      PieChartSectionData(
        color: Colors.green,
        value: totalIncome,
        title: 'Income: $totalIncome',
      ),
      PieChartSectionData(
        color: Colors.red,
        value: totalExpense,
        title: 'Expense: $totalExpense',
      ),
    ];
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'Income'),
        SizedBox(width: 10),
        _buildLegendItem(Colors.red, 'Expense'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
