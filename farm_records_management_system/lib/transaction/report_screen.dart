import 'package:farm_records_management_system/screens/add_harvest_page.dart';
import 'package:farm_records_management_system/screens/harvest_add.dart';
import 'package:farm_records_management_system/transaction/dataTable.dart';
import 'package:farm_records_management_system/transaction/financial_report.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.green.shade500,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Change icon color to white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Change title text color to white
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                InkWell(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  FinancialReportManagement(farmerID: 1,)),
                      );
                    },
                  child: _buildGridItem(
                    Icons.attach_money,
                    'Transactions',
                    '',
                    [Colors.red.shade400, Colors.red.shade600],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ReportTableScreen()),
                      );
                  },
                
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  HarvestListScreen()),
                      );
                  },
                  child: _buildGridItem(
                    Icons.outbox,
                    'Harvests',
                    '',
                    [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your onTap functionality here
                  },
                  child: _buildGridItem(
                    Icons.inventory,
                    'Treatments',
                    '',
                    [Colors.amber.shade400, Colors.amber.shade600],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your onTap functionality here
                  },
                  child: _buildGridItem(
                    Icons.bar_chart,
                    'Tasks',
                    '',
                    [Colors.purple.shade400, Colors.purple.shade600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, String subtitle, List<Color> gradientColors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(IconData icon, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.teal),
          onPressed: () {},
        ),
        Text(
          title,
          style: TextStyle(color: Colors.teal),
        ),
      ],
    );
  }
}