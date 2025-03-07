import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaflurt3/firebase_resources/authentication.dart';
// import 'package:instaflurt3/responsive/mobilescreen.dart';
// import 'package:instaflurt3/responsive/responsive_layout.dart';
// import 'package:instaflurt3/responsive/webscreen.dart';
import 'package:instaflurt3/screens/login_screen.dart';
import 'package:instaflurt3/utils/colors.dart';
// import 'package:instaflurt3/utils/global_variables.dart';
import 'package:instaflurt3/utils/utils.dart';
import 'package:instaflurt3/widgets/textfield_input.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    // _confirmpasswordController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> signupUser() async {
    setState(() {
      _isloading = true;
    });
    if (_image == null) {
      setState(() {
        _isloading = false; 
      });
      return showSnackBar('Please select an image', context);
    }
    String result = await Authentication().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      image: _image!,
    );

    if (result == 'Signup successful') {
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      showSnackBar(result, context);
      setState(() {
        _isloading = false;
      });
    }
    print(result);
  }

// funtion to navigate to login page
  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow resizing when keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo
                  instIcon,//InstFlurt icon
                const SizedBox(height: 20),
                // Profile Picture with Icon
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 80, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                'https://th.bing.com/th/id/OIP.1Agw8tPi1oidtC_q4U4ZdgHaHa?rs=1&pid=ImgDetMain')),
                    Positioned(
                      top: 100,
                      left: 120,
                      child: IconButton(
                        onPressed:
                            selectImage, //on pressing the image can be picked for profile
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Color.fromARGB(255, 52, 171, 226),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Text Fields

                TextfieldInput(
                  hinttext: 'Enter your Email',
                  textEditingController: _emailController,
                  textinputtype: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextfieldInput(
                  hinttext: 'Enter your User name',
                  textEditingController: _usernameController,
                  textinputtype: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextfieldInput(
                  hinttext: 'Enter your Bio',
                  textEditingController: _bioController,
                  textinputtype: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextfieldInput(
                  // key: _formKey,
                  hinttext: 'Enter your Password',
                  textEditingController: _passwordController,
                  textinputtype: TextInputType.visiblePassword,
                  ispassword: true,
                ),
                const SizedBox(height: 20),
                // TextfieldInput(
                //   // key: _formKey,
                //   hinttext: 'confirm your Password',
                //   textEditingController: _confirmpasswordController,
                //   textinputtype: TextInputType.visiblePassword,
                //   ispassword: true,
                // ),
                // const SizedBox(height: 20),
                // SignUp Button
                InkWell(
                  onTap: signupUser,
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            color: blueColor,
                          ),
                          child: const Text('SignUp'),
                        ),
                ),
                const SizedBox(height: 20),
                // Navigation to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    //for signup
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Text(
                        "LogIn.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
