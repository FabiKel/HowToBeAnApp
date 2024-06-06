import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/db/object_box.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/inventory_item.dart';
import 'package:htbah_app/models/note.dart';
import 'package:htbah_app/models/skill.dart';
import 'package:objectbox/objectbox.dart';

abstract class Prov {
  static final objBox = Provider<ObjectBox>((ref) {
    throw UnimplementedError();
  });
  static final charaBox = Provider<Box<Character>>((ref) {
    return ref.read(objBox).store.box<Character>();
  });
  static final notesBox = Provider<Box<Note>>((ref) {
    return ref.read(objBox).store.box<Note>();
  });
  static final itemsBox = Provider<Box<InventoryItem>>((ref) {
    return ref.read(objBox).store.box<InventoryItem>();
  });
  static final skillsBox = Provider<Box<Skill>>((ref) {
    return ref.read(objBox).store.box<Skill>();
  });
}
