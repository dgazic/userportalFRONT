import 'package:flutter/material.dart';

class MyHorizontalDivider extends StatelessWidget {
  const MyHorizontalDivider(
      {Key? key, this.padding = const EdgeInsets.symmetric(vertical: 4)})
      : super(key: key);
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(height: 1),
    );
  }
}
