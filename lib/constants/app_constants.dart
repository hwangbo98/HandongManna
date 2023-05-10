import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class AppConstants {
  static const appTitle = "Flutter Chat Demo";
  static const loginTitle = "Login";
  static const homeTitle = "Home";
  static const settingsTitle = "Settings";
  static const fullPhotoTitle = "Full Photo";
  static const register = "Register";
}


class Common{

}

class BlurImage extends StatelessWidget {
  final String imageUrl;
  final double blurIntensity;

  const BlurImage({
    Key? key,
    required this.imageUrl,
    this.blurIntensity = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: blurIntensity,
              sigmaY: blurIntensity,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class BlurText extends StatelessWidget {
  final String content;
  final double blurIntensity;
  final TextStyle style;

  const BlurText({
    Key? key,
    required this.content,
    this.blurIntensity = 10.0,
    required this.style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          '${content}',
          style: style,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: blurIntensity,
              sigmaY: blurIntensity,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}