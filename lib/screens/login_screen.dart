// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instaflurt3/firebase_resources/authentication.dart';
// import 'package:instaflurt3/firebase_resources/google.dart';
// import 'package:instaflurt3/screens/signupscreen.dart';
import 'package:instaflurt3/utils/colors.dart';
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

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'Login successful') {
      setState(() {
        _isLoading = false;
      });
      // pending
    } else {
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.toString())));
    }
    print(res.toString());
  }

  // void signInWithGoogle() async {}

  // void signOut() async {
  //   await _authService.signOut();
  // }

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
              Text(
                'InstaFlurt',
                style: GoogleFonts.robotoSlab(
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),

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
                onTap: loginUser,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ))
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          color: blueColor,
                        ),
                        child: Text('Login'),
                      ),
              ),

              SizedBox(height: 30),
              //transition to signup page

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {},
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
      ),
    );
  }
}
