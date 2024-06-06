import 'package:flutter/material.dart';
import 'package:htbah_app/app/inventory_page/inventory_page.dart';
import 'package:htbah_app/app/widgets/inventory_list_tile.dart';
import 'package:htbah_app/app/widgets/list_view_separator.dart';
import 'package:htbah_app/models/character.dart';

class InventoryOverview extends StatefulWidget {
  final Character chara;

  const InventoryOverview(this.chara, {super.key});

  @override
  State<InventoryOverview> createState() => _InventoryOverviewState();
}

class _InventoryOverviewState extends State<InventoryOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Inventar",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryPage(widget.chara),
                    ),
                  ).then((_) => setState(() {}));
                },
                icon: const Icon(Icons.menu),
              ),
            )
          ],
        ),
        Expanded(
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
      ],
    );
  }
}
