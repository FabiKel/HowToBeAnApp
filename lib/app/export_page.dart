import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/start.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
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
              onPressed: () => export(),
              child: const Text("Export nach..."),
            ),
          ),
        ],
      ),
    );
  }

  void export() async {
    await getExternalStorageDirectory().then((dir) async {
      if (dir != null) {
        final date = DateTime.now();
        final fileName = "${dir.path}/htbaa-exp-${date.year}_${date.month}_"
            "${date.day}-${date.hour}:${date.minute}.json";
        final file = File(fileName);
        final selected = charas.entries.where((entry) => entry.value).map((e) {
          return e.key;
        }).toList();
        await file.writeAsString(jsonEncode(selected)).then((_) {
          if (file.existsSync()) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Start()),
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Inhalte wurden exportiert."),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Inhalte wurden NICHT exportiert. "
                    "Datei konnte nicht geschrieben werden"),
              ),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inhalte wurden NICHT exportiert. "
                "Ordner konnte nicht gefunden werden."),
          ),
        );
      }
    });
  }
}
