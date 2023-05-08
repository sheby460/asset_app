  import 'dart:io';

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

getmyDocument() async{
  FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).snapshots().listen((event) {
    myDocument = event;
  });

}
Future<String> uploadImageToFirebase(File file) async{
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

Future<bool>uploadCostCenterData(Map<String,dynamic>eventData) async{
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isCompleted = false;
 await FirebaseFirestore.instance.collection('cost_centers').add(eventData).then((value) {
  isCompleted =true;
  Get.snackbar('Cost Center', 'uploaded successful', colorText: Colors.white,
  backgroundColor: Colors.blue);
 }).catchError((e){
  isCompleted = false;
 });
 return isCompleted = false;
}
  
}