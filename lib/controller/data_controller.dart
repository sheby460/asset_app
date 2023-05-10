  import 'dart:io';

import 'package:asset_app/nav/bottom_nav.dart';
import 'package:asset_app/view/home_screen.dart';
import 'package:asset_app/view/unit_cost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;

class DataController extends GetxController{
  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot?  myDocument;
  var isCostCenterInfoLoading = false.obs;
  var isUnitCostSave = false.obs;

getmyDocument() async{
  FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).snapshots().listen((event) {
    myDocument = event;
  });

}
Future<String> uploadImageToFirebaseStorage(File file) async{
  String fileUrl = " ";
 String fileName = Path.basename(file.path);

 
 var reference = FirebaseStorage.instance.ref().child("myfiles/$fileName");
 UploadTask uploadTask = reference.putFile(file);
 TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
 await taskSnapshot.ref.getDownloadURL().then((value) {
  fileUrl = value;
 });
 return fileUrl;
} 

uploadCostCenterData(String imageUrl, String costName, String location,String description) async{
  String uid = FirebaseAuth.instance.currentUser!.uid;
 await FirebaseFirestore.instance.collection('cost_centers').doc().set({
    'imageUrl': imageUrl,
    'costName': costName,
    'location': location,
    'description': description,
    'createdBy': uid
  }).then((value) {
     Get.snackbar('cost center','created succsessful',colorText: Colors.white,
     backgroundColor: Colors.blue);
    isCostCenterInfoLoading(false);
     Get.offAll( const HomeScreen());
  });
}

// uploadUnitCostData(String imageUrl, String unitName, String location,String description) async{
// String uid = FirebaseAuth.instance.currentUser!.uid;
//  await FirebaseFirestore.instance.collection('unit cost').doc().set({
//     'imageUrl': imageUrl,
//     'unitName': unitName,
//     'location': location,
//     'description': description,
//     'cost_center_id': widget.costCenterId,
//     'createdBy': uid
//   }).then((value) {
//      Get.snackbar('unit cost ','created succsessful',colorText: Colors.white,
//      backgroundColor: Colors.blue);
//     isUnitCostSave(false);
//      Get.offAll(  const UnitCostsPage());
//   });
// }
  
}