import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/inventory_item.dart';

class InventoryItemPage extends ConsumerWidget {
  final Character chara;
  final InventoryItem? item;

  const InventoryItemPage({required this.chara, this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _item = item ??
        InventoryItem(
          name: "",
          description: "",
          image: "",
        );

    final itemNameController = TextEditingController(text: _item.name);
    final itemDescController = TextEditingController(text: _item.description);

    bool added = item != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, added),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: itemNameController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: "Item Name",
          ),
          maxLines: 1,
          style: const TextStyle(fontSize: 23),
          onChanged: (input) {
            _item.name = input;
            if (!added) {
              chara.inventory.add(_item);
              chara.save(ref.read(Prov.charaBox));
              added = true;
            } else {
              _item.save(ref.read(Prov.itemsBox));
            }
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: itemDescController,
          expands: true,
          maxLines: null,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Beschreibung..."
          ),
          textAlignVertical: TextAlignVertical.top,
          onChanged: (input) {
            _item.description = input;
            if (!added) {
              chara.inventory.add(_item);
              chara.save(ref.read(Prov.charaBox));
              added = true;
            } else {
              _item.save(ref.read(Prov.itemsBox));
            }
          },
        ),
      ),
    );
  }
}
