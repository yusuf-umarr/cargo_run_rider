  import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(String message, context,{Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.red,
      ),
    );
  }

  Future<File> myUploadImage() async {
  final imagePicker = ImagePicker();
  XFile? image;

  var file = File("");

  image = await imagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 25);

  if (image != null) {
    file = File(image.path);
  }

  try {
    return file;
  } catch (e) {
    return File("");
  }
}
