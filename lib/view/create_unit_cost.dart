import 'dart:io';
import 'package:asset_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/my_widget.dart';

class CreateUnitCostPage extends StatefulWidget {
  final String costCenterId;

  const CreateUnitCostPage({required this.costCenterId, Key? key})
      : super(key: key);

  @override
  _CreateUnitCostPageState createState() => _CreateUnitCostPageState();
}

class _CreateUnitCostPageState extends State<CreateUnitCostPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitNameController = TextEditingController();
  TextEditingController locationController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');

  File? unitImage;

  bool _isSaving = false;

  @override
  void dispose() {
    unitNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveUnitCost() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        await FirebaseFirestore.instance.collection('unit_costs').add({
          'imageUrl': unitImage?.path,
          'name': unitNameController.text,
          'location': locationController.text,
          'description': descriptionController.text,
          'cost_center_id': widget.costCenterId,
        });

        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save unit cost: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    unitImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    unitImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Image.asset(
                  'assets/gallary.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Unit Cost'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  imagePickDialog();
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grey,
                      width: 1,
                    ),
                  ),
                  child: unitImage != null
                      ? Image.file(
                          unitImage!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: unitNameController,
                decoration: const InputDecoration(
                  labelText: 'Unit Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 30),
           ElevatedButton(
  onPressed: _isSaving ? null : _saveUnitCost,
  child: _isSaving
      ? CircularProgressIndicator()
      : Text('Save'),
),
            ],
          ),
        ),
      ),
    );
  }
}
