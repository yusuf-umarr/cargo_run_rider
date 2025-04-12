  import 'dart:io';
import 'package:intl/intl.dart';

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

 String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }


    String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    DateFormat formatter = DateFormat('d MMM. yyyy');
    return formatter.format(parsedDate);
  }

  String formatTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(parsedDate);
  }
