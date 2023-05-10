import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/app_color.dart';

class CreateAssetPage extends StatefulWidget {
  final String costCenterId;
  final String unitCostId;

  const CreateAssetPage(
      {super.key, required this.costCenterId, required this.unitCostId});

  @override
  State<CreateAssetPage> createState() => _CreateAssetPageState();
}

class _CreateAssetPageState extends State<CreateAssetPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController assetNameController = TextEditingController();
  TextEditingController assetPriceController = TextEditingController();
  TextEditingController assetDepriciationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? assetImage;

  bool _isSaving = false;
  String? _validateDepreciationAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter depreciation amount';
    }

    final double depreciationAmount = double.tryParse(value) ?? 0.0;
    final double assetPrice = double.tryParse(assetPriceController.text) ?? 0.0;

    if (depreciationAmount > assetPrice) {
      return 'Depreciation amount cannot exceed asset price';
    }

    return null;
  }

  @override
  void dispose() {
    assetNameController.dispose();
    assetPriceController.dispose();
    assetDepriciationController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveAsset() async {
    if (_formKey.currentState!.validate()) {
        final String? depreciationAmountValidation = _validateDepreciationAmount(assetDepriciationController.text);

      if (depreciationAmountValidation != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(depreciationAmountValidation),
          backgroundColor: Colors.red,
        ));
        return;
      }
      setState(() {
        _isSaving = true;
      });

      try {
        await FirebaseFirestore.instance.collection('assets').add({
          'imageUrl': assetImage?.path,
          'name': assetDepriciationController.text,
          'asset_price': assetPriceController.text,
          'asset_depreciation': assetDepriciationController.text,
          'location': locationController.text,
          'description': descriptionController.text,
          'cost_center_id': widget.costCenterId,
          'unitId': widget.unitCostId,
        });

        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to craete assets: $e'),
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
                    assetImage = File(image.path);
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
                    assetImage = File(image.path);
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
        title: const Text('Create asset'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  imagePickDialog();
                },
                child: Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(top: 35),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(70),
                      gradient: const LinearGradient(colors: [
                        Color(0xff7DDCFB),
                        Color(0xffBC67F2),
                        Color(0xffACF6AF),
                        Color(0xffF95549),
                      ])),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70)
                            ),
                            child: assetImage == null
                             ? const CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                                size: 50,
                              ),
                             ):CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.white,
                              backgroundImage: FileImage(assetImage!),
                             )
                          )
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: assetNameController,
                decoration: const InputDecoration(
                  labelText: 'Asset Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter asset name';
                  }
                  return null;
                },
              ),
              SizedBox(height: Get.height * 0.008),
              TextFormField(
                controller: assetPriceController,
                decoration: const InputDecoration(
                  labelText: 'assets price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter asset price';
                  }
                  return null;
                },
              ),
              SizedBox(height: Get.height * 0.008),
              TextFormField(
                controller: assetDepriciationController,
                decoration: const InputDecoration(
                  labelText: 'asset depriciation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter asset depriaciation';
                  }
                  
                  return null;
                },
              ),
              SizedBox(height: Get.height * 0.008),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'asset location inside unit',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: Get.height * 0.008),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 19),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveAsset,
                child: _isSaving ? CircularProgressIndicator() : Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
