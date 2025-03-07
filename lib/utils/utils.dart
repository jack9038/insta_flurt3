import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? image = await imagePicker.pickImage(source: source);

  if (image != null) {
    return await image.readAsBytes();
  }
  print('no image selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

pickVideo(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? video = await imagePicker.pickVideo(source: source);

  if (video != null) {
    return await video.readAsBytes();
  }
  print('no video selected');
}


final instIcon = Text(
  'InstaFlurt',
  style: GoogleFonts.robotoSlab(
    fontSize: 50,
    fontStyle: FontStyle.italic,
    color: const Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.bold,
  ),
);
