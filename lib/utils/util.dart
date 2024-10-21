  import 'package:flutter/material.dart';

void showSnackBar(String message, context,{Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.red,
      ),
    );
  }