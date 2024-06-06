import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/character_page/character_page_skillbar.dart';
import 'package:htbah_app/app/deletion_page.dart';
import 'package:htbah_app/app/not_implemented_helper.dart';
import 'package:htbah_app/app/widgets/chara_info_wrapper.dart';
import 'package:htbah_app/app/widgets/lp_tile.dart';
import 'package:htbah_app/app/widgets/notes_overview.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';

class CharacterPage extends ConsumerStatefulWidget {
  final Character chara;

  const CharacterPage(this.chara, {super.key});

  @override
  ConsumerState<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends ConsumerState<CharacterPage> {
  final nameController = TextEditingController();
  final nameFocus = FocusNode();
  bool editName = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.chara.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !editName
            ? null
            : IconButton(
                onPressed: () => setState(() {
                  editName = false;
                }),
                icon: const Icon(Icons.check),
              ),
        title: Hero(
          tag: "chara_name_${widget.chara.name}",
          child: !editName
              ? Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.chara.name,
                    style: const TextStyle(fontSize: 22),
                  ),
                )
              : TextField(
                  focusNode: nameFocus,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {
                    widget.chara.name = input;
                    widget.chara.save(ref.read(Prov.charaBox));
                  },
                ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return _CharaEditDialog(widget.chara);
                },
              ).then((action) async {
                if (action == null) return;
                if (action == 0) {
                  setState(() => editName = true);
                  await Future.delayed(const Duration(milliseconds: 100));
                  nameFocus.requestFocus();
                } else if (action == 1) {
                  // TODO: export
                  NotImplemented.show(context);
                } else if (action == 2) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DeletionPage(widget.chara);
                    }),
                        (route) => false,
                  );
                }
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Life points ------------------------------------------ Life points
          LPTile(widget.chara),
          // Notes ------------------------------------------------------ Notes
          NotesOverview(widget.chara),
          // Character Info ------------------------------------ Character Info
          CharaInfoWrapper(widget.chara),
          // Chara Skills ---------------------------------------- Chara Skills
          CharaPSkillBar(widget.chara),
        ],
      ),
    );
  }
}

class _CharaEditDialog extends StatelessWidget {
  final Character chara;

  const _CharaEditDialog(this.chara, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("doch nicht"),
        ),
      ],
      content: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context, 0),
              icon: const Icon(Icons.edit),
              label: const Text(
                "Namen ändern",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, 1),
              icon: const Icon(Icons.import_export),
              label: const Text(
                "Exportieren",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              height: 2,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.black26,
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, 2),
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              label: const Text(
                "Löschen",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
