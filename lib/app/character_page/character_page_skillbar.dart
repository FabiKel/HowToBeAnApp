import 'package:flutter/material.dart';
import 'package:htbah_app/app/skills_page.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/skill.dart';

class CharaPSkillBar extends StatelessWidget {
  final Character chara;

  const CharaPSkillBar(this.chara, {super.key});

  @override
  Widget build(BuildContext context) {
    void pushSkillPage(SkillType type, String title) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkillsPage(
            type: type,
            chara: chara,
            title: title,
          ),
        ),
      );
    }

    return Hero(
      tag: "skills_hero",
      child: DarkContainerBox(
        background: Colors.black54,
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Material(
          // needed for hero
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  onTap: () => pushSkillPage(SkillType.action, "Handeln"),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Icon(Icons.pan_tool),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => pushSkillPage(SkillType.wisdom, "Wissen"),
                  child: const Icon(Icons.question_mark),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  onTap: () => pushSkillPage(SkillType.social, "Sozial"),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 25),
                    child: Icon(Icons.question_answer),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
