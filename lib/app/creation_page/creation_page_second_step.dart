import 'package:flutter/material.dart';
import 'package:htbah_app/models/character.dart';

class CreationPageSecondStep extends StatelessWidget {
  final Character newChara;

  const CreationPageSecondStep(this.newChara, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black26,
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: const InputDecoration(
          label: Text("Anmerkungen und Fähigkeiten"),
        ),
        textAlignVertical: TextAlignVertical.top,
        maxLines: null,
        expands: true,
        controller: TextEditingController(text: newChara.description),
        onChanged: (input) {
          newChara.description = input;
        },
      ),
    );
  }
}
