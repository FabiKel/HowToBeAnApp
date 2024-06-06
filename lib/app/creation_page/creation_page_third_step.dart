import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:htbah_app/app/widgets/skill_list_tile.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/skill.dart';

class CreationPageThirdStep extends StatefulWidget {
  final Character newChara;
  final String title;
  final SkillType type;

  const CreationPageThirdStep({
    required this.newChara,
    required this.type,
    required this.title,
    super.key,
  });

  @override
  State<CreationPageThirdStep> createState() => _CreationPageThirdStepState();
}

class _CreationPageThirdStepState extends State<CreationPageThirdStep> {
  final skillTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void updateSkill() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final int sp = widget.newChara.getSPByType(widget.type);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black26,
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title, style: const TextStyle(fontSize: 22)),
            subtitle: Text("insg. ${widget.newChara.spUsed} Punkte verteilt"),
            trailing: Text(
              "$sp P. | +${sp ~/ 10}",
              style: const TextStyle(fontSize: 23),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: skillTextController,
                  decoration: const InputDecoration(
                    label: Text("Skillname"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  onPressed: () {
                    if (skillTextController.text.isEmpty) return;
                    setState(() {
                      widget.newChara.skills.add(
                        Skill(
                          name: skillTextController.text,
                          value: 10,
                          typeIndex: widget.type.index,
                        ),
                      );
                      skillTextController.clear();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          // Skill List -------------------------------------------- Skill List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                children: widget.newChara.skills
                    .where((e) => e.type == widget.type)
                    .map((e) => SkillListTile(
                          e,
                          widget.newChara,
                          updateSkill,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
