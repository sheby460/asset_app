import 'dart:io';
import 'package:asset_app/controller/data_controller.dart';
import 'package:asset_app/utils/app_color.dart';
import 'package:asset_app/widgets/my_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/auth_controller.dart';

class CostCenterScreen extends StatefulWidget {
const CostCenterScreen({Key? key}) : super(key: key);

  @override
  State<CostCenterScreen> createState() => _CostCenterScreenState();
}

class _CostCenterScreenState extends State<CostCenterScreen> {
   GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController costNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descrptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

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
                    myfiles = File(image.path);
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
                    myfiles = File(image.path);
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

  File? myfiles;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  int selectedRadio = 0;

  AuthController? authController;
  DataController? dataController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Get.width * 0.1,
                ),
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
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7DDCFB),
                          Color(0xffBC67F2),
                          Color(0xffACF6AF),
                          Color(0xffF95549),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: myfiles == null
                              ? const CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                              size: 50,
                            ),
                          )
                              : CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            backgroundImage: FileImage(
                              myfiles!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.width * 0.1,
                ),
                textField(
                    text: 'Cost Name',
                    controller: costNameController,
                    validator: (String input) {
                      if (costNameController.text.isEmpty) {
                        Get.snackbar('Warning', 'Cost Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Location',
                    controller: locationController,
                    validator: (String input) {
                      if (locationController.text.isEmpty) {
                        Get.snackbar('Warning', 'Location is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Description',
                    inputType: TextInputType.phone,
                    controller: descrptionController,
                    validator: (String input) {
                      if (descrptionController.text.isEmpty) {
                        Get.snackbar('Warning', 'Description is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                     }
                   }),
                 
                Obx(()=> dataController!.isCostCenterInfoLoading.value? const Center(child: CircularProgressIndicator(),) :Container(
                  height: 50,
                  margin: EdgeInsets.only(top: Get.height * 0.02),
                  width: Get.width,
                  child: elevatedButton(
                    text: 'Save',
                    onpress: () async{
                      if(myfiles == null){
                        Get.snackbar(
                            'Warning', "Image is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (!formKey.currentState!.validate()) {
                        return null;
                      }

                     

                      authController!.isProfileInformationLoading(true);
                      dataController!.isCostCenterInfoLoading(true);

                      String imageUrl = await dataController!.uploadImageToFirebaseStorage(myfiles!);

                      dataController!.uploadCostCenterData(imageUrl, costNameController.text.trim(), locationController.text.trim(), 
                      descrptionController.text.trim());

                    },
                  ),
                )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}