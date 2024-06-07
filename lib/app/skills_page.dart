import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/app/widgets/design/list_view_separator.dart';
import 'package:htbah_app/app/widgets/skill_list_tile.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/skill.dart';

class SkillsPage extends ConsumerStatefulWidget {
  final SkillType type;
  final String title;
  final Character chara;

  const SkillsPage({
    required this.type,
    required this.chara,
    required this.title,
    super.key,
  });

  @override
  ConsumerState<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends ConsumerState<SkillsPage> {
  final newSkillController = TextEditingController();
  bool edit = false;

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
        title: Text(widget.title),
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
          _SkillsMetaInfo(chara: widget.chara, type: widget.type),
          if (edit)
            DarkContainerBox(
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
              child: DarkContainerBox(
                margin: const EdgeInsets.all(10),
                child: ListView.separated(
                  itemCount: skills.length,
                  separatorBuilder: (c, i) {
                    if (edit) return const SizedBox();
                    return const ListViewSeparator();
                  },
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

class _SkillsMetaInfo extends ConsumerStatefulWidget {
  final Character chara;
  final SkillType type;

  const _SkillsMetaInfo({required this.chara, required this.type, super.key});

  @override
  ConsumerState<_SkillsMetaInfo> createState() => _SkillsMetaInfoState();
}

class _SkillsMetaInfoState extends ConsumerState<_SkillsMetaInfo> {
  @override
  Widget build(BuildContext context) {
    final gbp = widget.chara.getGBPByType(widget.type);
    final index = widget.type.index;

    // Backup for older Characters
    if(widget.chara.gbpUsed.isEmpty) widget.chara.gbpUsed = [0, 0, 0];

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: DarkContainerBox(
            margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => setState(() {
                if(widget.chara.gbpUsed[index] == gbp) return;
                widget.chara.gbpUsed[index] += 1;
                widget.chara.save(ref.read(Prov.charaBox));
              }),
              onLongPress: () => setState(() {
                widget.chara.gbpUsed[index] = 0;
                widget.chara.save(ref.read(Prov.charaBox));
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("GBP", style: TextStyle(fontSize: 25)),
                  Text(
                    "${gbp - widget.chara.gbpUsed[index]}/$gbp",
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: DarkContainerBox(
            margin: const EdgeInsets.fromLTRB(5, 10, 10, 0),
            child: Text(
              "+${widget.chara.getBaseValByType(widget.type)}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
      ],
    );
  }
}
