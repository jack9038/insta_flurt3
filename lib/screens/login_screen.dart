// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_resources/authentication.dart';

import 'package:instaflurt3/responsive/mobilescreen.dart';
import 'package:instaflurt3/responsive/responsive_layout.dart';
import 'package:instaflurt3/responsive/webscreen.dart';
import 'package:instaflurt3/screens/signupscreen.dart';
// import 'package:instaflurt3/screens/signupscreen.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:instaflurt3/utils/utils.dart';
import 'package:instaflurt3/widgets/textfield_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final AuthService _authService = AuthService();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> loginUserFunc() async {
    setState(() {
      _isLoading = true;
    });
    String result = await Authentication().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (result == 'Login successful') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobile: MobileScreenLayout(),
            web: Webscreen(),
          ),
        ),
      );
      // pending
    } else if (_emailController.text.isEmpty &&
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please provide both Input Field'),
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.toString())));
    }
    setState(() {
      _isLoading = false;
    });
  }

  // void signInWithGoogle() async {}

  // void signOut() async {
  //   await _authService.signOut();
  // }

  // funtion to navigate to signup page
  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Signupscreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                instIcon, // InstaFlurt icon
                SizedBox(height: 40),

                //textfield input email
                SizedBox(height: 60),
                TextfieldInput(
                  hinttext: 'Enter your Email',
                  textEditingController: _emailController,
                  textinputtype: TextInputType.emailAddress,
                ),

                //textfield password
                SizedBox(height: 20),
                TextfieldInput(
                  hinttext: 'Enter your Password',
                  textEditingController: _passwordController,
                  textinputtype: TextInputType.visiblePassword,
                  ispassword: true,
                ),
                //button login
                SizedBox(height: 20),
                InkWell(
                  onTap: loginUserFunc,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color: blueColor,
                          ),
                          child: Text('Login'),
                        ),
                ),

                const SizedBox(height: 30),
                //transition to signup page

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Don't have an account?"),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Signup.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),

                // InkWell(
                //   onTap: signInWithGoogle,
                //   child: ElevatedButton.icon(
                //     icon: const Icon(Icons.login),
                //     label: const Text('Sign in with Google'),
                //     onPressed: () async {
                //       final user = await _authService.signInWithGoogle();
                //       if (user != null) {
                //         print("Signed in as ${user.displayName}");
                //         // Navigate to the home screen
                //       }
                //     },
                //   ),
                // ),
                // InkWell(
                //   onTap: signOut,
                //   child: ElevatedButton.icon(
                //     icon: const Icon(Icons.login),
                //     onPressed: () {
                //       _authService.signOut();
                //     },
                //     label: Text('press'),
                //   ),
                // )
              ],
            ),
          )),
        ));
  }
}
