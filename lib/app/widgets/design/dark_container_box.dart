import 'package:flutter/material.dart';

class DarkContainerBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? background;

  const DarkContainerBox({
    required this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.background,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background ?? Colors.black26,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: margin ?? const EdgeInsets.all(10),
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }
}
