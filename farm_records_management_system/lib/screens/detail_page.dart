import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String cropList, fieldList, cropDescription, cropCompany, cropType, cropLotNumber, cropHarvest;

  Details({
    Key? key,
    required this.cropList,
    required this.fieldList,
    required this.cropDescription,
    required this.cropCompany,
    required this.cropType,
    required this.cropLotNumber,
    required this.cropHarvest, required cropName, required String cropPlotNumber, required String seedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Details'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Card(
        elevation: 2,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.more_vert),
                    ),
                    Text(
                      cropList,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Divider(thickness: .5, color: Colors.black54),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildRow('Crop Name:', cropList),
              _buildRow('Field Name:', fieldList),
              _buildRow('Seed Quantity:', cropDescription),
              _buildRow('Crop Company:', cropCompany),
              _buildRow('Crop Type:', cropType),
              _buildRow('Lot Number:', cropLotNumber),
              _buildRow('Estimated Harvest:', cropHarvest),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 50, bottom: 10),
              child: Text(
                value,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
