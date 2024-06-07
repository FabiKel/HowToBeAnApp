import 'package:flutter/material.dart';

class ListViewSeparator extends StatelessWidget {
  const ListViewSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 3,
      margin: const EdgeInsets.fromLTRB(25, 5, 25, 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
