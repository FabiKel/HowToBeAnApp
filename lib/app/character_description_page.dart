import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';

class CharacterDescriptionPage extends ConsumerWidget {
  final Character chara;
  const CharacterDescriptionPage(this.chara, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController(text: chara.description);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anmerkungen / Fähigkeiten"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: textController,
          expands: true,
          maxLines: null,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Text..."
          ),
          textAlignVertical: TextAlignVertical.top,
          onChanged: (input) {
            chara.description = input;
            chara.save(ref.read(Prov.charaBox));
          },
        ),
      ),
    );
  }
}
