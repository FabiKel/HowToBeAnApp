import 'package:flutter/material.dart';
import 'package:htbah_app/app/character_description_page.dart';
import 'package:htbah_app/models/character.dart';

class CharaDescription extends StatefulWidget {
  final Character chara;

  const CharaDescription(this.chara, {super.key});

  @override
  State<CharaDescription> createState() => _CharaDescriptionState();
}

class _CharaDescriptionState extends State<CharaDescription> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onLongPress: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDescriptionPage(widget.chara),
          ),
        ).then((value) => setState(() {}));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Anmerkungen / Fähigkeiten",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(widget.chara.description),
            ),
          ),
        ],
      ),
    );
  }
}
