import 'dart:io';
import 'package:asset_app/controller/data_controller.dart';
import 'package:asset_app/utils/app_color.dart';
import 'package:asset_app/widgets/my_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CostCenterScreen extends StatefulWidget {
const CostCenterScreen({Key? key}) : super(key: key);

  @override
  State<CostCenterScreen> createState() => _CostCenterScreenState();
}

class _CostCenterScreenState extends State<CostCenterScreen> {
  TextEditingController costNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  var selectedFrequency = -2;

  void resetControllers() {
   
    costNameController.clear();
    locationController.clear();
    descriptionController.clear();
   
    setState(() {});
  }

  var isCireatingCostCenter = false.obs;

  //  _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     initialDatePickerMode: DatePickerMode.day,
  //     firstDate: DateTime(2015),
  //     lastDate: DateTime(2101),
  //   );

    
  //   setState(() {});
  // }

   GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> mediaUrls = [];

  List media = [];

  // List<File> media = [];
  // List thumbnail = [];
  // List<bool> isImage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                iconWithTitle(text: 'Create Cost Center', func: () {}),
                
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                  height: Get.width * 0.6,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      color: AppColors.border.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: DottedBorder(
                    color: AppColors.border,
                    strokeWidth: 1.5,
                    dashPattern: [6, 6],
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          Container(
                            width: 76,
                            height: 59,
                            child: Image.asset('assets/uploadIcon.png'),
                          ),
                          myText(
                            text: 'Click and upload image',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          elevatedButton(
                              onpress: () async {
                                mediaDialog(context);
                              },
                              text: 'Upload')
                        ],
                      ),
                    ),
                  ),
                ),
                media.length == 0
                    ? Container()
                    : const SizedBox(
                  height: 20,
                ),

                media.length == 0
                    ? Container()
                    : Container(
                  width: Get.width,
                  height: Get.width * 0.3,
                  child: ListView.builder(
                      itemBuilder: (ctx, i) {
                        return
                            media[i].isVideo!
                          //!isImage[i]
                            ? Container(
                          width: Get.width * 0.3,
                          height: Get.width * 0.3,
                          margin: const EdgeInsets.only(
                              right: 15, bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(media[i].thumbnail!),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      child: IconButton(
                                        onPressed: () {
                                          media.removeAt(i);
                                          // media.removeAt(i);
                                          // isImage.removeAt(i);
                                          // thumbnail.removeAt(i);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.slow_motion_video_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                        )
                            : Container(
                          width: Get.width * 0.3,
                          height: Get.width * 0.3,
                          margin: const EdgeInsets.only(
                              right: 15, bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(media[i].image!),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  child: IconButton(
                                    onPressed: () {
                                      media.removeAt(i);
                                      // isImage.removeAt(i);
                                      // thumbnail.removeAt(i);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: media.length,
                      scrollDirection: Axis.horizontal),
                ),

                const SizedBox(
                  height: 20,
                ),
                myTextField(
                    bool: false,
                    icon: 'assets/4DotIcon.png',
                    text: 'Event Name',
                    controller: costNameController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Cost center name is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar(
                            'Opps', "COst center name is should be 3+ characters.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    }),

                const SizedBox(
                  height: 20,
                ),
                myTextField(
                    bool: false,
                    icon: 'assets/location.png',
                    text: 'Location',
                    controller: locationController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Location is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar('Opps', "Location is Invalid.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    }),
               
                              const SizedBox(
                  height: 20,
                ),
                myTextField(
                    bool: false,
                    icon: 'assets/description-icon.png',
                    text: 'Description',
                    controller: descriptionController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Description is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar('Opps', "Descripton is Invalid.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    }),
               const SizedBox(
                  height: 20,
                ),
         Obx(() => isCireatingCostCenter.value
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Container(
                  height: 42,
                  width: double.infinity,

                  child: elevatedButton(

                      onpress: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                isCireatingCostCenter(true);


                        DataController dataController = Get.put(DataController());

                        if(media.isNotEmpty){
                          for(int i=0;i<media.length;i++){
                            if(media[i].isVideo!){
                              /// if video then first upload video file and then upload thumbnail and
                              /// store it in the map

                        // String thumbnailUrl = await dataController.uploadThumbnailToFirebase(media[i].thumbnail!);

                        String videoUrl = await dataController.uploadImageToFirebase(media[i].video!);


                        

                            }else{
                              /// just upload image

                             String imageUrl = await dataController.uploadImageToFirebase(media[i].image!);
                            mediaUrls.add({
                              'url': imageUrl,
                              'isImage': true
                            });
                            }

                          }
                        }

                       Map<String, dynamic> eventData = {
                          'cost_name': costNameController.text,
                          'location': locationController.text,
                          'description': descriptionController.text,
                          
                          
                        };

                        await dataController.uploadCostCenterData(eventData)
                        .then((value) {
                          print("Event is done");
                          isCireatingCostCenter(false);
                          resetControllers();
                        });


                      },
                      text: 'Create Cost Center'),
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

  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    if (image != null) {
    
    }

    setState(() {});
    Navigator.pop(context);
  }

 
  void mediaDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Media Type"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, true);
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, false);
                    },
                    icon: const Icon(Icons.slow_motion_video_outlined)),
              ],
            ),
          );
        },
        context: context);
  }

  void imageDialog(BuildContext context, bool image) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Media Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.gallery);
                      } 
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                      }
                    },
                    icon: const Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: context);
  }
}
