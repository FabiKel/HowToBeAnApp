import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/app/widgets/design/snacker.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ExportPage extends ConsumerStatefulWidget {
  final Character? chara;

  const ExportPage({this.chara, super.key});

  @override
  ConsumerState<ExportPage> createState() => _ExportPAgeState();
}

class _ExportPAgeState extends ConsumerState<ExportPage> {
  late final Box<Character> charaBox;
  final Map<Character, bool> charas = {};

  @override
  void initState() {
    super.initState();
    charaBox = ref.read(Prov.charaBox);
    for (final chara in charaBox.getAll()) {
      if (widget.chara != null && chara.id == widget.chara!.id) {
        charas[chara] = true;
      } else {
        charas[chara] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Export"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DarkContainerBox(
              child: ListView.builder(
                itemCount: charas.length,
                itemBuilder: (c, i) {
                  final charaEntry = charas.entries.elementAt(i);
                  return CheckboxListTile(
                    title: Text(charaEntry.key.name),
                    subtitle: Text(charaEntry.key.shortDesc),
                    value: charaEntry.value,
                    onChanged: (val) => setState(() {
                      charas[charaEntry.key] = val ?? false;
                    }),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ElevatedButton(
              onPressed: () async => await export(),
              child: const Text("Exportieren"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> export() async {
    await getTemporaryDirectory().then((dir) async {
      try {
        final date = DateTime.now();
        final fileName = "${dir.path}/htbaa-exp-${date.year}_${date.month}_"
            "${date.day}-${date.hour}:${date.minute}.json";
        final file = File(fileName);

        final selected = charas.entries.where((e) => e.value).map((entry) {
          return entry.key;
        }).toList();
        final content = jsonEncode(selected);

        await file.writeAsString(content);
        await FilePicker.platform
            .saveFile(
          dialogTitle: "Wähle einen Speicherort",
          fileName: fileName,
          bytes: await file.readAsBytes(),
        )
            .then((filePath) {
          if (filePath == null) {
            Snacker.showSnackbar(context, "Speichervorgang abgebrochen");
          } else {
            Snacker.showSnackbar(context, "Datei erfolgreich gespeichert");
          }
        });
        await file.delete();
      } catch (e) {
        Snacker.showSnackbar(context, "DATEIFEHLER: $e");
      }
    });
  }


}
