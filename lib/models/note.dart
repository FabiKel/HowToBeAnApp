import 'package:htbah_app/models/character.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  @Id()
  int id;
  String title;
  String text;
  int? _updated;
  final int created;
  final characterNote = ToOne<Character>();

  Note({
    this.id = 0,
    required this.title,
    required this.text,
    required this.created,
  });

  @Transient()
  String get shortText {
    if (text.length <= 100) return text;
    return text.substring(0, 101);
  }

  set updated(int val) {
    _updated = val;
  }

  int get updated {
    return _updated ?? created;
  }

  void save(Box<Note> notesBox) {
    updated = DateTime.now().millisecondsSinceEpoch;
    notesBox.put(this);
  }

  void delete(
    Box<Note> notesBox, {
    Character? chara,
    Box<Character>? charaBox,
  }) {
    notesBox.remove(id);
    if(chara != null && charaBox != null) {
      chara.notes.removeWhere((note) => note.id == id);
      chara.save(charaBox);
    }
  }
}
