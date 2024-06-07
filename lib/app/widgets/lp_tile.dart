import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';

class LPTile extends ConsumerStatefulWidget {
  final Character chara;

  const LPTile(this.chara, {super.key});

  @override
  ConsumerState<LPTile> createState() => _LPTileState();
}

class _LPTileState extends ConsumerState<LPTile> {
  @override
  Widget build(BuildContext context) {
    return DarkContainerBox(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ListTile(
        onLongPress: () => setState(() {
            widget.chara.lp = widget.chara.lpMax;
            widget.chara.save(ref.read(Prov.charaBox));
          }),
        onTap: () async {
          await showDialog<int>(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Schaden / Heilung"),
                content: _AlertContent(),
              );
            },
          ).then((value) {
            if(value == null) return;
            setState(() {
                if (value + widget.chara.lp >= widget.chara.lpMax) {
                  widget.chara.lp = widget.chara.lpMax;
                } else {
                  widget.chara.lp += value;
                }
              });
            widget.chara.save(ref.read(Prov.charaBox));
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text("Lebenspunkte"),
        subtitle: Text("Max: ${widget.chara.lpMax}"),
        trailing: Text(
          "${widget.chara.lp}",
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

class _AlertContent extends StatelessWidget {
  const _AlertContent({super.key});

  @override
  Widget build(BuildContext context) {
    final lpInputController = TextEditingController();

    return SizedBox(
      height: 165,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "0",
            ),
            controller: lpInputController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 80,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    child: const Icon(Icons.add),
                    onTap: () {
                      Navigator.pop(
                        context,
                        (int.tryParse(lpInputController.text) ?? 0).abs(),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    child: const Icon(Icons.remove),
                    onTap: () {
                      Navigator.pop(
                        context,
                        (int.tryParse(lpInputController.text) ?? 0).abs() * -1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
