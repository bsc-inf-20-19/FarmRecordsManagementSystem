import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/plant/detail_page.dart';

class CropDetailsTabbedPage extends StatefulWidget {
  final Map<String, dynamic> crop;

  const CropDetailsTabbedPage({Key? key, required this.crop}) : super(key: key);

  @override
  _CropDetailsTabbedPageState createState() => _CropDetailsTabbedPageState();
}

class _CropDetailsTabbedPageState extends State<CropDetailsTabbedPage> {
  late TextEditingController _nameController;
  late TextEditingController _harvestUnitsController;
  late TextEditingController _notesController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.crop['name']);
    _harvestUnitsController = TextEditingController(text: widget.crop['harvestUnits']);
    _notesController = TextEditingController(text: widget.crop['notes']);
  }

  Future<void> _updateCropDetails() async {
    final updatedCrop = {
      'name': _nameController.text,
      'harvestUnits': _harvestUnitsController.text,
      'notes': _notesController.text,
    };
    await DatabaseHelper.instance.updateCrop(widget.crop['id'], updatedCrop);

    // Update plantings with the new crop name
    await DatabaseHelper.instance.updatePlantingsCropName(widget.crop['name'], _nameController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Crop details updated successfully')),
    );
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _deleteCrop() async {
    await DatabaseHelper.instance.deleteCrop(widget.crop['id']);
    Navigator.pop(context, true);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this crop?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCrop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.crop['name']),
          backgroundColor: Colors.green.shade700,
          actions: [
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _updateCropDetails,
              )
            else
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white, width: 4.0),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            tabs: const [
              Tab(text: 'Details'),
              Tab(text: 'Planting'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetailsTab(),
            CropPlantingView(crop: widget.crop),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            readOnly: !_isEditing,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _harvestUnitsController,
            decoration: const InputDecoration(labelText: 'Harvest Units'),
            readOnly: !_isEditing,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            readOnly: !_isEditing,
          ),
        ],
      ),
    );
  }
}

class CropPlantingView extends StatelessWidget {
  final Map<String, dynamic> crop;

  const CropPlantingView({Key? key, required this.crop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Details(
      cropName: crop['name'],
      cropCompany: '', 
      cropType: '', 
      cropPlotNumber: '', 
      cropHarvest: '', 
      seedType: '',
    );
  }
}
