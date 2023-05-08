import 'package:asset_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_color.dart';
import '../widgets/my_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int selectedRadio = 0;
  TextEditingController forgetPasswordController = TextEditingController();

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  bool isSignUp = false;
  late AuthController authController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.08),
                  isSignUp
                      ? myText(
                          text: 'Sign Up',
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : myText(
                          text: 'Login',
                          style: GoogleFonts.poppins(
                              fontSize: 23, fontWeight: FontWeight.w600)),
                  SizedBox(height: Get.height * 0.03),
                  isSignUp
                      ? Container(
                          child: myText(
                            text:
                                'Welcome please sign up if you dont have an account. ',
                            style: GoogleFonts.roboto(
                              letterSpacing: 0,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          child: myText(
                            text: 'Welcome please Login to continue...',
                            style: GoogleFonts.roboto(
                              letterSpacing: 0,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  SizedBox(height: Get.height * 0.03),
                  Container(
                    width: Get.width * 0.55,
                    child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      labelPadding: EdgeInsets.all(Get.height * 0.01),
                      indicatorColor: Colors.black,
                      onTap: (v) {
                        setState(() {
                          isSignUp = !isSignUp;
                        });
                      },
                      tabs: [
                        myText(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                        myText(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Container(
                      width: Get.width,
                      height: Get.height * 0.6,
                      child: Form(
                        key: formKey,
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            LogInWidget(),
                            SignUpWidget(),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  Widget LogInWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              myTextField(
                bool: false,
                icon: 'assets/mail.png',
                text: 'exaple@gmai.com',
                validator: (String input) {
                  if (input.isEmpty) {
                    Get.snackbar('warning', 'email is required',
                        colorText: Colors.white, backgroundColor: Colors.blue);
                    return '';
                  }

                  if (!input.contains('@')) {
                    Get.snackbar('warning', 'Email is invalid',
                        colorText: Colors.white, backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: emailController,
              ),
              SizedBox(height: Get.height * 0.02),
              myTextField(
                bool: true,
                icon: 'assets/lock.png',
                text: 'password',
                validator: (String input) {
                  if (input.isEmpty) {
                    Get.snackbar('warning', 'password required',
                        colorText: Colors.white, backgroundColor: Colors.blue);
                    return '';
                  }

                  if (input.length < 6) {
                    Get.snackbar(
                    'warning', 'password length must be 6 or greater',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: passwordController,
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: 'forget password',
                      content: Container(
                        width: Get.width,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: myTextField(
                                bool: false,
                                icon: 'assets/lock.png',
                                text: 'Enter your Email',
                                controller: forgetPasswordController,
                              ),
                            ),
                            const SizedBox(height: 10),
                            MaterialButton(
                              onPressed: () {
                                authController.forgetPassword(
                                    forgetPasswordController.text.trim());
                              },
                              minWidth: double.infinity,
                              child: const Text('Sent'),
                            ),
                          ],
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.02,
                  ),
                  child: myText(
                      text: 'Forget Password',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black)),
                ),
              )
            ],
          ),
          Obx(() => authController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(
                    vertical: Get.height * 0.02,
                  ),
                  width: Get.width,
                  child: elevatedButton(
                      text: 'Login',
                      onpress: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        authController.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      }))),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myText(
            text: 'Or connect with',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            )
          ),
                    SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialAppsIcons(
                  text: 'assets/google.png',
                  onPressed: (){
                    authController.signInWithGoogle();

                  }

              ),
            ],
          )
        ],
      ),
    );
  }

  Widget SignUpWidget() {
    return  SingleChildScrollView(
              child: Column(
          children: [


            myTextField(
                bool: false,
                icon: 'assets/mail.png',
                text: 'Email',
                validator: (String input){
                  if(input.isEmpty){
                    Get.snackbar('Warning', 'Email is required.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }

                  if(!input.contains('@')){
                    Get.snackbar('Warning', 'Email is invalid.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: emailController
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
                bool: true,
                icon: 'assets/lock.png',
                text: 'password',
                validator: (String input){
                  if(input.isEmpty){
                    Get.snackbar('Warning', 'Password is required.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }

                  if(input.length <6){
                    Get.snackbar('Warning', 'Password should be 6+ characters.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: passwordController
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
                bool: false,
                icon: 'assets/lock.png',
                text: 'Re-enter password',
                validator: (input){
                  if(input != passwordController.text.trim()){
                    Get.snackbar('Warning', 'Confirm Password is not same as password.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: confirmPasswordController
            ),
           Obx(()=> authController.isLoading.value? const Center(child: CircularProgressIndicator(),) : Container(
             height: 50,
             margin: EdgeInsets.symmetric(
               vertical: Get.height * 0.04,
             ),
             width: Get.width,
             child: elevatedButton(
               text: 'Sign Up',
               onpress: () {

                 if(!formKey.currentState!.validate()){
                   return;
                 }

                 authController.signUp(email: emailController.text.trim(),password: passwordController.text.trim());



               },
             ),
           )),
            myText(
              text: 'Or Connect With',
              style: TextStyle(
                fontSize: Get.height * 0.025,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                socialAppsIcons(
                    text: 'assets/fb.png',
                    onPressed: (){
                    }
                ),

                socialAppsIcons(
                    text: 'assets/google.png',
                    onPressed: (){
                    }
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
                width: Get.width * 0.8,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: [
                    TextSpan(
                        text:
                        'By signing up, you agree our ',
                        style: TextStyle(
                            color: Color(0xff262628),
                            fontSize: 12)),
                    TextSpan(
                        text:
                        'terms, Data policy and cookies policy',
                        style: TextStyle(
                            color: Color(0xff262628),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ]),
                )),
          ],
        )
    );
  }
}
