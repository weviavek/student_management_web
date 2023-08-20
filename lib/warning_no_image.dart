import 'package:flutter/material.dart';

class WarngingNoImage {
 static void warn(BuildContext context,Future <void >onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Do you want to continue without adding an image?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No")),
          ElevatedButton(onPressed:()=>onPressed, child: const Text("Yes"))
        ],
      ),
    );
  }
}
