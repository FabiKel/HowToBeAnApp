import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/widgets/design/not_implemented_helper.dart';
import 'package:htbah_app/app/notes_page/note_page.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/app/widgets/item_delete_confirmation.dart';
import 'package:htbah_app/app/widgets/design/list_view_separator.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/note.dart';

class NotesPage extends StatefulWidget {
  final Character chara;

  const NotesPage(this.chara, {super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  void updateParent() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notizen"),
        actions: [
          IconButton(
            onPressed: () => NotImplemented.show(context),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => NotImplemented.show(context),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DarkContainerBox(
              margin: const EdgeInsets.all(10),
              child: ListView.separated(
                itemCount: widget.chara.notes.length,
                separatorBuilder: (c, i) => const ListViewSeparator(),
                itemBuilder: (c, i) {
                  final note = widget.chara.notes.elementAt(i);
                  return _NotesListTile(note, widget.chara, updateParent);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NotePage(chara: widget.chara);
                    },
                  ),
                ).then((value) => setState(() {}));
              },
              child: const Text("Neue Notiz"),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesListTile extends ConsumerWidget {
  final Note note;
  final Character chara;
  final void Function() update;

  const _NotesListTile(this.note, this.chara, this.update, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      isThreeLine: true,
      title: Text(note.title),
      subtitle: Text(
        "${DateTime.fromMillisecondsSinceEpoch(note.updated)}"
        "\n"
        "${note.shortText.replaceAll("\n", " ")}",
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotePage(chara: chara, note: note);
            },
          ),
        ).then((value) => update());
      },
      onLongPress: () async {
        await showDialog<bool?>(
            context: context,
            builder: (c) {
              return const ItemDeleteConfirmation("Notiz löschen?");
            }).then((val) {
          if (val ?? false) {
            note.delete(
              ref.read(Prov.notesBox),
              chara: chara,
              charaBox: ref.read(Prov.charaBox),
            );
            update();
          }
        });
      },
    );
  }
}
