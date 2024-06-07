import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/models/character.dart';

class CreationPageSecondStep extends StatelessWidget {
  final Character newChara;

  const CreationPageSecondStep(this.newChara, {super.key});

  @override
  Widget build(BuildContext context) {
    return DarkContainerBox(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Anmerkungen und Fähigkeiten",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Beschreibung..."
              ),
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              expands: true,
              controller: TextEditingController(text: newChara.description),
              onChanged: (input) {
                newChara.description = input;
              },
            ),
          ),
        ],
      ),
    );
  }
}
