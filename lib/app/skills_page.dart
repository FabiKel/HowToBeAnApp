import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/widgets/skill_list_tile.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/skill.dart';

class SkillsPage extends ConsumerStatefulWidget {
  final SkillType type;
  final Character chara;

  const SkillsPage(this.type, this.chara, {super.key});

  @override
  ConsumerState<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends ConsumerState<SkillsPage> {
  final newSkillController = TextEditingController();
  bool edit = false;

  String typeToText() {
    switch (widget.type) {
      case SkillType.action:
        return "Handeln [ ${widget.chara.spAct} | +${widget.chara.spAct ~/ 10} ]";
      case SkillType.wisdom:
        return "Wissen [ ${widget.chara.spWis} | +${widget.chara.spWis ~/ 10} ]";
      case SkillType.social:
        return "Sozial [ ${widget.chara.spSoc} | +${widget.chara.spSoc ~/ 10} ]";
    }
  }

  List<Skill> getSkillsByType() {
    switch (widget.type) {
      case SkillType.action:
        return widget.chara.skills.where((skill) {
          return skill.type == SkillType.action;
        }).toList();
      case SkillType.wisdom:
        return widget.chara.skills.where((skill) {
          return skill.type == SkillType.wisdom;
        }).toList();
      case SkillType.social:
        return widget.chara.skills.where((skill) {
          return skill.type == SkillType.social;
        }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final skills = getSkillsByType();
    return Scaffold(
      appBar: AppBar(
        title: Text(typeToText()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () => setState(() {
                edit = !edit;
              }),
              icon: edit ? const Icon(Icons.save) : const Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (edit)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black26,
              ),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newSkillController,
                      decoration: const InputDecoration(
                          hintText: "neuer Skill Name..."),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      widget.chara.skills.add(
                        Skill(
                          name: newSkillController.text,
                          value: 10,
                          typeIndex: widget.type.index,
                        ),
                      );
                      widget.chara.save(ref.read(Prov.charaBox));
                      newSkillController.clear();
                      FocusScope.of(context).unfocus();
                    }),
                    iconSize: 30,
                    padding: const EdgeInsets.all(15),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Hero(
              tag: "skills_hero",
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black26,
                ),
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: skills.length,
                  itemBuilder: (c, i) {
                    final skill = skills.elementAt(i);
                    return SkillListTile(
                      skill,
                      widget.chara,
                      () => setState(() {}),
                      display: !edit,
                      charaCreation: false,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
