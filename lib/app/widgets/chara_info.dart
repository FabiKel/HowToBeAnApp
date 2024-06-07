import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/widgets/design/basic_list_tile.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';

class CharaInfo extends ConsumerStatefulWidget {
  final Character chara;

  const CharaInfo(this.chara, {super.key});

  @override
  ConsumerState<CharaInfo> createState() => _CharaInfoState();
}

class _CharaInfoState extends ConsumerState<CharaInfo> {
  void updateProperty(String value, String title) {
    switch (title) {
      case "Geschlecht":
        widget.chara.gender = value;
        break;
      case "Alter":
        widget.chara.age = int.tryParse(value) ?? 0;
        break;
      case "Statur":
        widget.chara.body = value;
        break;
      case "Religion":
        widget.chara.religion = value;
        break;
      case "Beruf":
        widget.chara.profession = value;
        break;
      case "Familie":
        widget.chara.family = value;
        break;
      default:
        throw "UKNOW PROPERTY: $title";
    }
    widget.chara.save(ref.read(Prov.charaBox));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Charakter Info",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _CharaInfoItem(
                "Geschlecht",
                widget.chara.gender,
                updateProperty: updateProperty,
              ),
              _CharaInfoItem(
                "Alter",
                "${widget.chara.age}",
                isNumber: true,
                updateProperty: updateProperty,
              ),
              _CharaInfoItem(
                "Statur",
                widget.chara.body,
                updateProperty: updateProperty,
              ),
              _CharaInfoItem(
                "Religion",
                widget.chara.religion,
                updateProperty: updateProperty,
              ),
              _CharaInfoItem(
                "Beruf",
                widget.chara.profession,
                updateProperty: updateProperty,
              ),
              _CharaInfoItem(
                "Familienstand",
                widget.chara.family,
                updateProperty: updateProperty,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CharaInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isNumber;
  final void Function(String, String) updateProperty;

  const _CharaInfoItem(
    this.title,
    this.value, {
    required this.updateProperty,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return BasicListTile(
      title: title,
      subtitle: value,
      onLongPress: () => startEditing(context),
    );
  }

  void startEditing(BuildContext context) async {
    final tCont = TextEditingController(text: value);
    await showDialog<String>(
      context: context,
      builder: (c) {
        return AlertDialog(
          content: TextField(
            controller: tCont,
            keyboardType: isNumber ? TextInputType.number : null,
            inputFormatters: [
              if (isNumber) FilteringTextInputFormatter.digitsOnly
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("doch nicht"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, tCont.text);
              },
              child: const Text("speichern"),
            ),
          ],
        );
      },
    ).then((input) {
      if (input == null) return;
      updateProperty(input, title);
    });
  }
}
