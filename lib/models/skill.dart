import 'package:htbah_app/models/character.dart';
import 'package:objectbox/objectbox.dart';

enum SkillType {
  action,
  wisdom,
  social,
}

@Entity()
class Skill {
  @Id()
  int id;
  String name;
  int value;
  final characterSkill = ToOne<Character>();
  int typeIndex;

  @Transient()
  SkillType get type {
    _ensureStableEnumValues();
    return SkillType.values[typeIndex];
  }

  @Transient()
  set skillType(SkillType type) {
    _ensureStableEnumValues();
    typeIndex = type.index;
  }

  Skill({
    this.id = 0,
    required this.name,
    required this.value,
    required this.typeIndex,
  });

  void _ensureStableEnumValues() {
    assert(SkillType.action.index == 0);
    assert(SkillType.wisdom.index == 1);
    assert(SkillType.social.index == 2);
  }

  void save(Box<Skill> skillBox) {
    skillBox.put(this);
  }

  void delete(
    Box<Skill> skillBox, {
    Box<Character>? charaBox,
    Character? chara,
  }) {
    skillBox.remove(id);
    if (chara != null && charaBox != null) {
      chara.skills.removeWhere((skill) => skill.id == id);
      chara.save(charaBox);
    }
  }

  Map<String, dynamic> toJson() {
    final jsonMap = {
      "id": 0,
      "name": name,
      "value": value,
      "type": typeIndex,
    };
    return jsonMap;
  }

  factory Skill.fromJson(Map<String, dynamic> jsonMap) {
    return Skill(
      name: jsonMap["name"],
      value: jsonMap["value"],
      typeIndex: jsonMap["type"],
    );
  }
}
