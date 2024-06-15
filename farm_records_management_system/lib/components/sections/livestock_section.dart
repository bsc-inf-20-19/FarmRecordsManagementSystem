import 'package:flutter/material.dart';

class LivestockSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'management.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Plan, delegate, monitor jobs.\nGPS tracking included.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 10),
                          Text(
                            'Plan job',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Job type',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          children: [
                            _buildJobTypeCard(Icons.space_bar, 'Spray', Colors.orange.shade200),
                            _buildJobTypeCard(Icons.eco, 'Fertilize', Colors.green.shade200),
                            _buildJobTypeCard(Icons.opacity, 'Irrigate / Fertigate', Colors.blue.shade200),
                            _buildJobTypeCard(Icons.location_on, 'Multi-location', Colors.purple.shade200),
                            _buildJobTypeCard(Icons.agriculture, 'Harvest', Colors.orange.shade200),
                            _buildJobTypeCard(Icons.pets, 'Livestock', Colors.red.shade200),
                            _buildJobTypeCard(Icons.grass, 'Sow/plant', Colors.pink.shade200),
                            _buildJobTypeCard(Icons.content_cut, 'Pruning', Colors.red.shade200),
                            _buildJobTypeCard(Icons.add, 'Add new', Colors.red.shade200),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobTypeCard(IconData icon, String title, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
