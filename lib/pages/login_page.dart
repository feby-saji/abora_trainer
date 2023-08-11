import 'package:abora/constants/vars.dart';
import 'package:abora/functions/DB/db_functions.dart';
import 'package:abora/pages/home_page.dart';
import 'package:abora/constants/app_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart' as Rive;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isNewUser = false;

FocusNode _nameFocusNode = FocusNode();
ValueNotifier<String> errorMsg = ValueNotifier('');
TextEditingController emailCtrl = TextEditingController();
TextEditingController passwordCtrl = TextEditingController();
TextEditingController userNameCtrl = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    errorMsg.dispose();
    _nameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final blockSize = SizeConfig.blockSizeHorizontal!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(children: [
          SizedBox(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_bck_pg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken)),
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isNewUser ? blockSize * 17 : blockSize * 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/abora_logo.png',
                    width: isNewUser ? blockSize * 30 : blockSize * 40,
                    height: isNewUser ? blockSize * 30 : blockSize * 40,
                  ),
                ),
                SizedBox(height: blockSize * 3),
                Text(
                  'ABORA',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    letterSpacing: blockSize * 3.5,
                    fontSize: blockSize * 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'for TRAINER\'S',
                  style: kPoppinsMedium.copyWith(color: kWhite),
                ),
                SizedBox(height: blockSize * 5),
                Text(
                  'Keep Connected',
                  style: kPoppinsMedium.copyWith(
                      fontSize: blockSize * 5, color: kGreen),
                ),
                SizedBox(height: isNewUser ? blockSize * 14 : blockSize * 18),

                //? signIn options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: blockSize * 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: blockSize * 3, horizontal: blockSize * 2),
                      child: Column(
                        children: [
                          Text(
                            isNewUser
                                ? 'sign Up with email and password'
                                : 'sign In with email and password',
                            style: kPoppinsBold,
                          ),
                          SizedBox(height: blockSize * 1),
                          ValueListenableBuilder(
                            valueListenable: errorMsg,
                            builder: (BuildContext context, String text,
                                Widget? child) {
                              return Text(
                                text,
                                style: const TextStyle(color: Colors.red),
                              );
                            },
                          ),
                          SizedBox(height: blockSize * 3),
                          // TextField
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: blockSize * 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Visibility(
                              visible: isNewUser,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9a-zA-Z ]")),
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                focusNode: _nameFocusNode,
                                controller: userNameCtrl,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Username',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: blockSize * 2),

                          // TextField
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: blockSize * 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Form(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9a-zA-Z@.]")),
                                  LengthLimitingTextInputFormatter(40),
                                ],
                                validator: (value) =>
                                    EmailValidator.validate(value!)
                                        ? null
                                        : 'Please enter a valid email',
                                controller: emailCtrl,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: blockSize * 2),

                          // TextField
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: blockSize * 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: TextField(
                              obscureText: true,
                              controller: passwordCtrl,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          SizedBox(height: blockSize * 1),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kGreen,
                              ),
                              onPressed: () => isNewUser
                                  ? createUserWithEmail(context)
                                  : signInUserWithEmail(context),
                              child: const Text(
                                'Done',
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: blockSize * 3),
                GestureDetector(
                  onTap: () {
                    if (isNewUser) {
                      setState(() {
                        isNewUser = false;
                      });
                      print(isNewUser);
                    } else {
                      setState(() {
                        isNewUser = true;
                      });
                      print(isNewUser);
                    }
                  },
                  child: Text(
                    isNewUser ? 'existing user? sign In.' : 'New user? sign Up',
                    style: kPoppinsRegular,
                  ),
                ),
                SizedBox(height: blockSize * 3),

//? google signIN Button
                GestureDetector(
                  onTap: () => signInWithGoogle(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: blockSize * 2),
                    width: blockSize * 90,
                    height: blockSize * 15,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(children: [
                      SizedBox(width: blockSize * 5),
                      Image.asset('assets/images/google_logo.png'),
                      SizedBox(width: blockSize * 10),
                      Text(
                        'signIn with Google',
                        style: kPoppinsMedium.copyWith(
                            color: Colors.black, fontSize: blockSize * 4.5),
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// email & password
createUserWithEmail(BuildContext context) async {
  print('creating new user');
  if (userNameCtrl.text.isEmpty ||
      emailCtrl.text.isEmpty ||
      passwordCtrl.text.isEmpty) {
    return;
  }
  final navigator = Navigator.of(context);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
            child: SizedBox(
          width: 300,
          height: 300,
          child:
              // CircularProgressIndicator()
              Rive.RiveAnimation.asset('assets/rive/loading.riv'),
        ));
      });
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    );
    bool userNameExists = await DbServices()
        .checkTrainerNameExists(userNameCtrl.text.toLowerCase());
    if (userNameExists) {
      errorMsg.value = 'User name already taken';
      _nameFocusNode.requestFocus();
      navigator.pop();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await DbServices().addNewTrainer(userNameCtrl.text.toLowerCase());
      await prefs.setBool(SharedPrefVal().userLoggedIn, true);
      Future.delayed(const Duration(seconds: 2), () {
        Get.to(() => ShowCaseWidget(
            builder: Builder(builder: (context) => const HomeScreen())));
      });
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      navigator.pop();
      errorMsg.value = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      navigator.pop();
      errorMsg.value = 'email already in use';
    }
  } catch (e) {
    print(e);
    navigator.pop();
  }
}

signInUserWithEmail(BuildContext context) async {
  print('singning in user');

  final navigator = Navigator.of(context);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
            child: SizedBox(
          width: 300,
          height: 300,
          child:
              // CircularProgressIndicator()
              Rive.RiveAnimation.asset('assets/rive/loading.riv'),
        ));
      });
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    );
    print('loged in success');
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => ShowCaseWidget(
          builder: Builder(builder: (context) => const HomeScreen())));
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefVal().userLoggedIn, true);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      errorMsg.value = 'No user found for that email.';
      navigator.pop();
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      navigator.pop();
      errorMsg.value = 'Wrong password provided for that user.';
    }
  }
}

// Google singIN
Future<UserCredential> signInWithGoogle(BuildContext context) async {
  final navigator = Navigator.of(context);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
            child: SizedBox(
          width: 300,
          height: 300,
          child:
              // CircularProgressIndicator()
              Rive.RiveAnimation.asset('assets/rive/loading.riv'),
        ));
      });

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);

  if (authResult.additionalUserInfo!.isNewUser) {
    await DbServices().addNewTrainer(
        FirebaseAuth.instance.currentUser!.displayName?.toLowerCase());
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => ShowCaseWidget(
          builder: Builder(builder: (context) => const HomeScreen())));
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefVal().userLoggedIn, true);
  } else {
    print('trying to sign in user');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefVal().userLoggedIn, true);
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => ShowCaseWidget(
          builder: Builder(builder: (context) => const HomeScreen())));
    });
  }

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
