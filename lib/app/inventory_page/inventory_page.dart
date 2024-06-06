import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/inventory_page/inventory_item_page.dart';
import 'package:htbah_app/app/widgets/inventory_list_tile.dart';
import 'package:htbah_app/app/widgets/list_view_separator.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/inventory_item.dart';

class InventoryPage extends ConsumerStatefulWidget {
  final Character chara;

  const InventoryPage(this.chara, {super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventar"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black26,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                itemCount: widget.chara.inventory.length,
                separatorBuilder: (c, i) => const ListViewSeparator(),
                itemBuilder: (c, i) {
                  final item = widget.chara.inventory.elementAt(i);
                  return InventoryListTile(
                    item,
                    widget.chara,
                    () => setState(() {}),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return InventoryItemPage(chara: widget.chara);
                    },
                  ),
                ).then((value) => setState(() {}));
              },
              child: const Text("Neues Item"),
            ),
          ),
        ],
      ),
    );
  }
}
