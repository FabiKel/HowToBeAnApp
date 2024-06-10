import 'dart:convert';

import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class InventoryItem {
  @Id()
  int id;
  String name;
  String description;
  String image;
  final characterInvItem = ToOne<Character>();

  InventoryItem({
    this.id = 0,
    required this.name,
    required this.description,
    required this.image,
  });

  @Transient()
  String get shortDesc {
    if (description.length <= 50) return description;
    return description.substring(0, 51);
  }

  void save(Box<InventoryItem> itemsBox) => itemsBox.put(this);

  void delete(
    Box<InventoryItem> itemsBox, {
    Box<Character>? charaBox,
    Character? chara,
  }) {
    itemsBox.remove(id);
    if (charaBox != null && chara != null) {
      chara.inventory.removeWhere((item) => item.id == id);
      chara.save(charaBox);
    } else if (charaBox != null || chara != null) {
      throw "chara and charaBox have to be both null or non null";
    }
  }

  String toJson() {
    final jsonMap = {
      "id": id,
      "name": name,
      "description": description,
      "image": image,
    };
    return jsonEncode(jsonMap);
  }

  factory InventoryItem.fromJson(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    return InventoryItem(
      name: jsonMap["name"],
      description: jsonMap["description"],
      image: jsonMap["image"],
    );
  }
}
