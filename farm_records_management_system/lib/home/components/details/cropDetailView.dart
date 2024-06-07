import 'package:flutter/material.dart';

class CropDetailView extends StatelessWidget {
  CropDetailView({Key? key, required this.cropList,
  required this.fieldList, required this.seedQuantity, 
  required this.cropCompany, required this.cropType, 
  required this.cropLotNumber, required this.cropHarvest}) 
  : super(key: key);

  String cropList, fieldList, seedQuantity, cropCompany, 
  cropType, cropLotNumber, cropHarvest;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            CropItem(label: 'Planting Date', value: 'March 15, 2024'),
            CropItem(label: 'Crop Name', value: cropList),
            CropItem(label: 'Seed Quantity', value: seedQuantity),
            CropItem(label: 'Estimated Harvest', value: cropHarvest),
            CropItem(label: 'Seed Type', value: cropType),
            CropItem(label: 'Seed Lot Number', value: cropLotNumber),
            CropItem(label: 'Field Name', value: fieldList),
          ],
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
