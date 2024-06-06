import 'package:flutter/material.dart';

class ListViewSeparator extends StatelessWidget {
  const ListViewSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: const Icon(
        Icons.circle,
        size: 12,
        color: Colors.white10,
      ),
    );
  }
}
