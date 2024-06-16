import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.green.shade500,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Change icon color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Change title text color to white
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Report'),
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
                    // Add your onTap functionality here
                  },
                  child: _buildGridItem(
                    Icons.attach_money,
                    'Transactions',
                    '',
                    [Colors.yellow.shade400, Colors.yellow.shade600],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your onTap functionality here
                  },
                  child: _buildGridItem(
                    Icons.add_box,
                    'Plantings',
                    '',
                    [Colors.green.shade400, Colors.green.shade600],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your onTap functionality here
                  },
                  child: _buildGridItem(
                    Icons.outbox,
                    'Harvests',
                    '',
                    [Colors.amber.shade400, Colors.amber.shade600],
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
                    [Colors.yellow.shade400, Colors.yellow.shade600],
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
                InkWell(
                  onTap: () {
                    // Add your onTap functionality here
                  },
                  child: _buildGridItem(
                    Icons.description,
                    'Farm Notes',
                    '',
                    [Colors.blue.shade400, Colors.blue.shade600],
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