import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as Path;
import '../auth/profile_screen.dart';
import '../view/home_screen.dart';

class AuthController extends GetxController{
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  void login({String? email, String? password}){
   isLoading(true);
   auth.signInWithEmailAndPassword(email: email!, password: password!).then((value) {
    isLoading(false);
    Get.to(() => const HomeScreen());
   }).catchError((e){
    Get.snackbar('Error', '$e',backgroundColor: Colors.blue,colorText: Colors.white);
    isLoading(false);
   });
  }

  void signUp({String? email, String? password}){
   isLoading(true);
   auth.createUserWithEmailAndPassword(email: email!, password: password!).then((value) {
   isLoading(false);
   Get.to(() => const ProfileScreen());
   }).catchError((e){
    print('Error in Authentication is $e');
   });
  }

  void forgetPassword(String email){
  auth.sendPasswordResetEmail(email: email).then((value) {
    Get.back();
    Get.snackbar('password reset email sent', 'check your email',backgroundColor: Colors.blue,colorText: Colors.white);
  }).catchError((e){
    print('Error $e');
  });
  }

  signInWithGoogle() async{
  isLoading(true);
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
   FirebaseAuth.instance.signInWithCredential(credential).then((value) {
    isLoading(false);
    Get.to(() => const HomeScreen());
   }).catchError((e){
    isLoading(false);
     print("Error in authenticate $e");

   });
  }
var isProfileInformationLoading = false.obs;
  

  Future<String> uploadImageToFirebaseStorage(File image) async{
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var refference = FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = refference.putFile(image);
    TaskSnapshot taskSnapshot =await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) => {
      imageUrl = value,
    }).catchError((e){
      print('Error $e');
    });
    return imageUrl;
  }

  uploadProfileData(String imageUrl, String firstName, String lastName,String mobileNumber, String dob, String gender){
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'imageUrl': imageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(() => const HomeScreen());
    });
  }
}