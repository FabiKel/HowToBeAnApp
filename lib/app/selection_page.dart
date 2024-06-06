import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/character_page/character_page.dart';
import 'package:htbah_app/app/creation_page/creation_page.dart';
import 'package:htbah_app/app/deletion_page.dart';
import 'package:htbah_app/app/not_implemented_helper.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/objectbox.g.dart';

class SelectionPage extends ConsumerStatefulWidget {
  const SelectionPage({super.key});

  @override
  ConsumerState<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends ConsumerState<SelectionPage> {
  late final Box<Character> charaBox;
  late List<Character> charas;

  late final Stream<Query<Character>> watcher;
  late final StreamSubscription<Query<Character>> sub;

  @override
  void initState() {
    super.initState();
    charaBox = ref.read(Prov.charaBox);
    charas = charaBox.getAll();
    watcher = charaBox.query(Character_.isHidden.equals(false)).watch();
    sub = watcher.listen((event) {
      setState(() => charas = charaBox.getAll());
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HowToBeAnApp"),
        actions: [
          IconButton(
            onPressed: () => NotImplemented.show(context),
            icon: const Icon(Icons.settings_applications, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black26,
              ),
              margin: const EdgeInsets.all(10),
              child: ListView.separated(
                itemCount: charas.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 0);
                },
                itemBuilder: (context, index) {
                  final chara = charas.elementAt(index);
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.circle, size: 12),
                      title: Hero(
                        tag: "chara_name_${chara.name}",
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            chara.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "${chara.spUsed} SP - \"${chara.shortDesc}\""
                            .replaceAll("\n", " "),
                        softWrap: false,
                        overflow: TextOverflow.clip,
                      ),
                      trailing: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return CharacterPage(chara);
                          }),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreationPage()),
                );
              },
              child: const Text("Neuer Charakter"),
            ),
          ),
        ],
      ),
    );
  }
}
