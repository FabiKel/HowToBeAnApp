import 'dart:convert';

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
  List<int> gbpUsed;
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

  /// the int val for given skill: all skill point of skill / 10 and rounded
  int getBaseValByType(SkillType type) {
    double val = getSPByType(type).toDouble();
    return (val / 10).round();
  }

  /// the "Geistesblitzpunkte" by skill type
  int getGBPByType(SkillType type) {
    double val = getBaseValByType(type).toDouble();
    return (val / 10).round();
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
    this.gbpUsed = const [0, 0, 0],
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

  String toJson() {
    final jsonMap = {
      "name": name,
      "created": created.millisecondsSinceEpoch,
      "updated":
          updated?.millisecondsSinceEpoch ?? created.millisecondsSinceEpoch,
      "gender": gender,
      "age": age,
      "lp": lp,
      "lpMax": lpMax,
      "body": body,
      "religion": religion,
      "profession": profession,
      "family": family,
      "image": image,
      "description": description,
      "isHidden": isHidden,
      "gbpUsed": gbpUsed,
      "skills": skills,
      "notes": notes,
      "inventory": inventory,
    };
    return jsonEncode(jsonMap);
  }

  factory Character.fromJson(Map<String, dynamic> jsonMap) {
    late final List<int> gbpUsed;
    if(jsonMap["gbpUsed"] == null || (jsonMap["gbpUsed"] as List).isEmpty) {
      gbpUsed = [0, 0, 0];
    } else {
      gbpUsed = List<int>.from(jsonMap["gbpUsed"]);
    }
    final chara = Character(
      name: jsonMap["name"],
      created: DateTime.fromMillisecondsSinceEpoch(jsonMap["created"]),
      updated: DateTime.fromMillisecondsSinceEpoch(jsonMap["updated"]),
      gender: jsonMap["gender"],
      age: jsonMap["age"],
      lp: jsonMap["lp"],
      lpMax: jsonMap["lpMax"],
      body: jsonMap["body"],
      religion: jsonMap["religion"],
      profession: jsonMap["profession"],
      family: jsonMap["family"],
      image: jsonMap["image"],
      description: jsonMap["description"],
      isHidden: jsonMap["isHidden"],
      gbpUsed: gbpUsed,
    );
    for(final item in jsonMap["skills"]) {
      final Skill skill = Skill.fromJson(item);
      chara.skills.add(skill);
    }
    for(final item in jsonMap["notes"]) {
      final Note note = Note.fromJson(item);
      chara.notes.add(note);
    }
    for(final item in jsonMap["inventory"]) {
      final InventoryItem invItem = InventoryItem.fromJson(item);
      chara.inventory.add(invItem);
    }
    return chara;
  }
}
