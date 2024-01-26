import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  double? width;
  double? height;
  double? fontSize;
  CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = Colors.blue,
    this.width = 300,
    this.height = 50,
    this.fontSize = 18,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // foregroundColor: Color.fromARGB(255, 24, 181, 29),
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(text,
            style: TextStyle(color: Colors.white, fontSize: fontSize)),
      ),
    );
  }
}
