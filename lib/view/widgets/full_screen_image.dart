import 'package:flutter/material.dart';

class FullScreenImageDialog extends StatelessWidget {
  final MemoryImage image;

  const FullScreenImageDialog({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
