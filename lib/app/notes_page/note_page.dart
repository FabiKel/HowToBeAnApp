import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/note.dart';

class NotePage extends ConsumerWidget {
  final Character chara;
  final Note? note;

  const NotePage({required this.chara, this.note, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _note = note ??
        Note(
          title: "",
          text: "",
          created: DateTime.now().millisecondsSinceEpoch,
        );

    final noteTitleController = TextEditingController(text: _note.title);
    final noteTextController = TextEditingController(text: _note.text);

    bool added = note != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, added),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: noteTitleController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: "Titel",
          ),
          maxLines: 1,
          style: const TextStyle(fontSize: 23),
          onChanged: (input) {
            _note.title = input;
            if (!added) {
              chara.notes.add(_note);
              chara.save(ref.read(Prov.charaBox));
              added = true;
            } else {
              _note.save(ref.read(Prov.notesBox));
            }
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: noteTextController,
          expands: true,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Notizen..."
          ),
          textAlignVertical: TextAlignVertical.top,
          onChanged: (input) {
            _note.text = input;
            if (!added) {
              chara.notes.add(_note);
              chara.save(ref.read(Prov.charaBox));
              added = true;
            } else {
              _note.save(ref.read(Prov.notesBox));
            }
          },
        ),
      ),
    );
  }
}
