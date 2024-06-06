import 'package:flutter/material.dart';

class ItemDeleteConfirmation extends StatelessWidget {
  final String title;
  const ItemDeleteConfirmation(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              borderRadius: BorderRadius.circular(15),
              child: const SizedBox(
                height: 100,
                child: Icon(Icons.delete_forever),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(15),
              child: const SizedBox(
                height: 100,
                child: Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
