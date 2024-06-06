import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/inventory_page/inventory_item_page.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/inventory_item.dart';

import 'item_delete_confirmation.dart';

class InventoryListTile extends ConsumerStatefulWidget {
  final InventoryItem item;
  final Character chara;
  final void Function() update;
  const InventoryListTile(this.item, this.chara, this.update, {super.key});

  @override
  ConsumerState<InventoryListTile> createState() => _InventoryListTileState();
}

class _InventoryListTileState extends ConsumerState<InventoryListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventoryItemPage(
                chara: widget.chara,
                item: widget.item,
              ),
            ),
          ).then((value) => setState(() {}));
        },
        onLongPress: () async {
          await showDialog<bool?>(
              context: context,
              builder: (c) {
                return const ItemDeleteConfirmation("Item löschen?");
              }).then((val) {
            if (val ?? false) {
              widget.item.delete(
                ref.read(Prov.itemsBox),
                chara: widget.chara,
                charaBox: ref.read(Prov.charaBox),
              );
              widget.update();
            }
          });
        },
        leading: const Icon(Icons.circle, size: 12),
        title: Text(widget.item.name),
        subtitle: Text(widget.item.shortDesc.replaceAll("\n", " ")),
      ),
    );
  }
}
