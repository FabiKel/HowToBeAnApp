import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htbah_app/app/creation_page/creation_page_first_step.dart';
import 'package:htbah_app/app/creation_page/creation_page_focus.dart';
import 'package:htbah_app/app/creation_page/creation_page_third_step.dart';
import 'package:htbah_app/db/provider.dart';
import 'package:htbah_app/models/character.dart';
import 'package:htbah_app/models/skill.dart';

import 'creation_page_second_step.dart';

class CreationPage extends ConsumerStatefulWidget {
  const CreationPage({super.key});

  @override
  ConsumerState<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends ConsumerState<CreationPage> {
  late PageController pageViewController;
  int pageIndex = 0;
  late CreationPageFocusManager focusManager;
  late Character newChara;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
    focusManager = CreationPageFocusManager();
    newChara = Character.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neuer Charakter"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.looks_one, color: getColor(0, pageIndex)),
                Icon(Icons.chevron_right, color: getColor(1, pageIndex)),
                Icon(Icons.looks_two, color: getColor(1, pageIndex)),
                Icon(Icons.chevron_right, color: getColor(2, pageIndex)),
                Icon(Icons.looks_3, color: getColor(2, pageIndex)),
                Icon(Icons.chevron_right, color: getColor(3, pageIndex)),
                Icon(Icons.looks_4, color: getColor(3, pageIndex)),
                Icon(Icons.chevron_right, color: getColor(4, pageIndex)),
                Icon(Icons.looks_5, color: getColor(4, pageIndex)),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageViewController,
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                setState(() => pageIndex = index);
              },
              children: [
                CreationPageFirstStep(newChara, focusManager),
                CreationPageSecondStep(newChara),
                CreationPageThirdStep(
                  newChara: newChara,
                  title: "Handeln",
                  type: SkillType.action,
                ),
                CreationPageThirdStep(
                  newChara: newChara,
                  title: "Wissen",
                  type: SkillType.wisdom,
                ),
                CreationPageThirdStep(
                  newChara: newChara,
                  title: "Sozial",
                  type: SkillType.social,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                if (pageIndex > 0)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pageViewController.animateToPage(
                          --pageIndex,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastEaseInToSlowEaseOut,
                        );
                      });
                    },
                    icon: const Icon(Icons.arrow_circle_left_outlined),
                  ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: continueAction,
                    child: Text(pageIndex != 4 ? "Weiter" : "Speichern"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color? getColor(int marker, int index) {
    if (marker - index < 0) return Colors.blueGrey;
    if (marker - index == 0) return Colors.green;
    return null;
  }

  void continueAction() {
    if(pageIndex != 4) {
      setState(() {
        pageViewController.animateToPage(
          ++pageIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.fastEaseInToSlowEaseOut,
        );
      });
    } else {
      newChara.save(ref.read(Prov.charaBox));
      Navigator.pop(context);
    }
  }
}
