import 'package:flutter/cupertino.dart';
import 'package:htbah_app/models/inventory_item.dart';
import 'package:htbah_app/models/skill.dart';
import 'package:objectbox/objectbox.dart';

import 'note.dart';

@Entity()
class Character {
  @Id()
  int id;
  String name;

  @Property(type: PropertyType.date)
  final DateTime created;
  @Property(type: PropertyType.date)
  DateTime? updated;

  String gender;
  int age;
  int lp;
  int lpMax;
  String body;
  String religion;
  String profession;
  String family;
  String image;
  String description;
  bool isHidden;
  @Backlink("characterSkill")
  final skills = ToMany<Skill>();
  @Backlink("characterNote")
  final notes = ToMany<Note>();
  @Backlink("characterInvItem")
  final inventory = ToMany<InventoryItem>();

  @Transient()
  int get spUsed => getSPByType();

  @Transient()
  int get spAct => getSPByType(SkillType.action);

  @Transient()
  int get spWis => getSPByType(SkillType.wisdom);

  @Transient()
  int get spSoc => getSPByType(SkillType.social);

  int getSPByType([SkillType? type]) {
    int val = 0;
    for (final skill in skills) {
      if (type != null && skill.typeIndex != type.index) continue;
      val += skill.value;
    }
    return val;
  }

  @Transient()
  String get shortDesc {
    if (description.length <= 20) return description;
    return "${description.substring(0, 21)}...";
  }

  Character({
    this.id = 0,
    required this.name,
    required this.created,
    required this.updated,
    required this.gender,
    required this.age,
    required this.lp,
    required this.lpMax,
    required this.body,
    required this.religion,
    required this.profession,
    required this.family,
    required this.image,
    required this.description,
    required this.isHidden,
  });

  int save(Box<Character> charaBox) {
    return charaBox.put(this);
  }

  factory Character.empty() {
    return Character(
      name: "",
      created: DateTime.now(),
      updated: DateTime.now(),
      gender: "",
      age: 0,
      lp: 0,
      lpMax: 100,
      body: "",
      religion: "",
      profession: "",
      family: "",
      image: "",
      description: "",
      isHidden: false,
    );
  }
}
