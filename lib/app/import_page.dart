import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/start.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/app/widgets/design/list_view_separator.dart';
import 'package:htbah_app/app/widgets/design/snacker.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';

class ImportPage extends ConsumerStatefulWidget {
  final List<dynamic> jsonObj;

  const ImportPage(this.jsonObj, {super.key});

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  bool loading = true;
  Map<Character, bool> selection = {};

  @override
  void initState() {
    super.initState();
    loadCharas();
  }

  Future<void> loadCharas() async {
    for (final strChara in widget.jsonObj) {
      final chara = Character.fromJson(jsonDecode(strChara));
      selection[chara] = true;
    }
    setState(() => loading = false);
  }

  void import() {
    try {
      final charaBox = ref.read(Prov.charaBox);
      final selected = selection.entries
          .where((entry) {
            return entry.value;
          })
          .map((e) => e.key)
          .toList();
      charaBox.putMany(selected);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Start()),
        (route) => false,
      );
      Snacker.showSnackbar(
        context,
        "${selected.length} Charakter/e importiert",
      );
    } catch (e) {
      Snacker.showSnackbar(context, "FEHLER BEIM IMPORT:\n$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DarkContainerBox(
              child: loading
                  ? const _LoadingPlaceholder()
                  : ListView.separated(
                      itemCount: selection.length,
                      separatorBuilder: (c, i) => const ListViewSeparator(),
                      itemBuilder: (c, i) {
                        final entry = selection.entries.elementAt(i);
                        return CheckboxListTile(
                          value: entry.value,
                          onChanged: (val) => setState(() {
                            selection[entry.key] = val ?? false;
                          }),
                          title: Text(entry.key.name),
                          subtitle: Text(entry.key.shortDesc),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ElevatedButton(
              onPressed: selection.values.any((val) => val) ? import : null,
              child: const Text("Import"),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Lädt Datei"));
  }
}
