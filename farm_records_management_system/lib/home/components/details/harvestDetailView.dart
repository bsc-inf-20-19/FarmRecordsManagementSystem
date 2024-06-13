import 'package:flutter/material.dart';

class HarvestDetailView extends StatelessWidget {
  HarvestDetailView({Key? key, required this.cropList,
  required this.harvestNotes, required this.batchNo, 
  required this.harvestQuantity, required this.harvestQuality, 
  required this.unitCost, required this.harvestIncome}) 
  : super(key: key);

  String cropList, harvestNotes, batchNo, harvestQuantity,
  harvestQuality, unitCost, harvestIncome;

    @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Planting'),
        centerTitle: true,
      ),
      body: Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Crop Section',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(Icons.more_vert),
              ],
            ),
            SizedBox(height: 8),
            CropItem(label: 'Harvest Date', value: 'March 15, 2024'),
            CropItem(label: 'Crop Name', value: cropList),
            CropItem(label: 'BatchNo', value: batchNo),
            CropItem(label: 'Harvest quantity', value: harvestQuantity),
            CropItem(label: 'Harvest quality', value: harvestQuality),
            CropItem(label: 'Unit cost', value: unitCost),
            CropItem(label: 'Income from Harvest', value: harvestIncome),
            CropItem(label: 'Notes', value: harvestNotes),
          ],
        ),
      ),
    ),
    );
  
  }
}

class CropItem extends StatelessWidget {
  final String label;
  final String value;

  CropItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
