import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/skill.dart';

class SkillListTile extends ConsumerStatefulWidget {
  final Skill skill;
  final Character chara;
  final bool display;
  final bool charaCreation;
  final void Function() updateSkill;

  const SkillListTile(
    this.skill,
    this.chara,
    this.updateSkill, {
    this.display = false,
    this.charaCreation = true,
    super.key,
  });

  @override
  ConsumerState<SkillListTile> createState() => _SkillListTileState();
}

class _SkillListTileState extends ConsumerState<SkillListTile> {
  late final TextEditingController skillValueController;

  @override
  void initState() {
    super.initState();
    skillValueController = TextEditingController(text: "${widget.skill.value}");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.display) {
      return Material( // needed for hero -> list tile
        color: Colors.transparent,
        child: ListTile(
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.circle, size: 12),
          ),
          title: Text(
            widget.skill.name,
            style: const TextStyle(fontSize: 18),
          ),
          trailing: Text(
            "${widget.skill.value + widget.chara.getSPByType(widget.skill.type) ~/ 10}",
            style: const TextStyle(fontSize: 22),
          ),
        ),
      );
    }
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onLongPress: () {
              if (widget.charaCreation) {
                widget.chara.skills.removeWhere((skill) {
                  return skill.id == widget.skill.id;
                });
              } else {
                widget.skill.delete(
                  ref.read(Prov.skillsBox),
                  charaBox: ref.read(Prov.charaBox),
                  chara: widget.chara,
                );
              }
              widget.updateSkill();
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
              child: Text(
                widget.skill.name,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () => addSP(-1),
                      onLongPress: () => addSP(-10),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(4),
                      ),
                      child: const Icon(Icons.remove),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 30,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: skillValueController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                    ),
                    onEditingComplete: () {
                      onValueEnter(context, skillValueController.text);
                    },
                    onTapOutside: (_) {
                      onValueEnter(context, skillValueController.text);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: InkWell(
                      onTap: () => addSP(1),
                      onLongPress: () => addSP(10),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(15),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onValueEnter(BuildContext context, String input) {
    final input = skillValueController.text;
    widget.skill.value = int.tryParse(input) ?? 10;
    if (!widget.charaCreation) {
      widget.skill.save(ref.read(Prov.skillsBox));
    }
    FocusScope.of(context).unfocus();
  }

  void addSP(int val) {
    if ((widget.skill.value - val) < 0) return;
    widget.skill.value += val;
    skillValueController.text = "${widget.skill.value}";
    if (!widget.charaCreation) {
      widget.skill.save(ref.read(Prov.skillsBox));
    }
    widget.updateSkill();
  }
}
