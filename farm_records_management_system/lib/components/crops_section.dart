import 'package:farm_records_management_system/screens/activity_screen.dart';
import 'package:farm_records_management_system/widgets/crops/activity/activity_card.dart';
import 'package:farm_records_management_system/widgets/crops/activity/crop_list_card.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/screens/detail_page.dart';

class CropsSection extends StatelessWidget {
  const CropsSection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Details(cropCompany: '',cropHarvest: '', cropPlotNumber: '', cropType: '',)),
                    );
                  },
                  child: const CropListCard(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ActivityPage(plantingId: null,)),
                    );
                  },
                  child: const ActivityCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
