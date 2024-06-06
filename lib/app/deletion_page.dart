import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/start.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/inventory_item.dart';
import 'package:htbah_app/models/note.dart';
import 'package:htbah_app/models/skill.dart';
import 'package:htbah_app/objectbox.g.dart';

class DeletionPage extends ConsumerStatefulWidget {
  final Character chara;

  const DeletionPage(this.chara, {super.key});

  @override
  ConsumerState<DeletionPage> createState() => _DeletionPageState();
}

class _DeletionPageState extends ConsumerState<DeletionPage> {
  late final Box<Character> charaBox;
  late final Box<Note> notesBox;
  late final Box<Skill> skillsBox;
  late final Box<InventoryItem> itemsBox;
  late final int maxItems;

  bool deletionStarted = false;
  bool deletionDone = false;
  int deletedCount = 0;
  double percVal = 0;
  String infoText = "";

  @override
  void initState() {
    super.initState();
    charaBox = ref.read(Prov.charaBox);
    notesBox = ref.read(Prov.notesBox);
    skillsBox = ref.read(Prov.skillsBox);
    itemsBox = ref.read(Prov.itemsBox);
    maxItems = widget.chara.notes.length +
        widget.chara.skills.length +
        widget.chara.inventory.length +
        1; // for the character itself
  }

  void pushToStart() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Start()),
      (route) => false,
    );
  }

  void delete() async {
    for (final note in widget.chara.notes) {
      setState(() {
        if (notesBox.remove(note.id)) {
          infoText += "> Notiz ${note.id} gelöscht\n";
        } else {
          infoText += "> [ERROR] Notiz ${note.id} nicht gelöscht\n";
        }
        deletedCount++;
      });
      await Future.delayed(const Duration(milliseconds: 50));
    }

    for (final skill in widget.chara.skills) {
      setState(() {
        if (skillsBox.remove(skill.id)) {
          infoText += "> Skill ${skill.id} gelöscht\n";
        } else {
          infoText += "> [ERROR] Skill ${skill.id} nicht gelöscht\n";
        }
        deletedCount++;
      });
      await Future.delayed(const Duration(milliseconds: 50));
    }

    for (final item in widget.chara.inventory) {
      setState(() {
        if (itemsBox.remove(item.id)) {
          infoText += "> Item ${item.id} gelöscht\n";
        } else {
          infoText += "> [ERROR] Item ${item.id} nicht gelöscht\n";
        }
        deletedCount++;
      });
      await Future.delayed(const Duration(milliseconds: 50));
    }

    setState(() {
      infoText += "> Lösche Charakter...\n";
      charaBox.remove(widget.chara.id);
    });

    setState(() {
      infoText += "> Fertig";
      deletionDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    percVal = deletedCount / maxItems;
    if (deletionDone) percVal = 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if(!deletionStarted || deletionDone) {
                    pushToStart();
                  }
                },
              ),
        title: Text("Charakter \"${widget.chara.name}\" löschen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!deletionStarted)
              ElevatedButton(
                onPressed: () {
                  setState(() => deletionStarted = true);
                  delete();
                },
                child: Text(
                  "endgültig löschen".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            if (deletionStarted)
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(15),
                      child: CircularProgressIndicator(
                        value: percVal,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: !deletionDone
                        ? Text(
                            "${(percVal * 100).toInt()} %",
                            style: const TextStyle(fontSize: 25),
                          )
                        : const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 60,
                          ),
                  ),
                ],
              ),
            if (deletionStarted)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(infoText, style: const TextStyle(fontSize: 16)),
                ),
              ),
            if (deletionDone)
              ElevatedButton(
                onPressed: pushToStart,
                child: const Text("Weiter"),
              ),
          ],
        ),
      ),
    );
  }
}
