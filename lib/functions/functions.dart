import 'package:flutter/material.dart';



showReusableSnackBar(BuildContext context, String title)
{
  SnackBar snackBar = SnackBar(
    backgroundColor: Colors.deepPurple,
    duration: const Duration(seconds: 1),
    content: Text(
      title.toString(),
      style: const TextStyle(
        fontSize: 36,
        color: Colors.white,
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}