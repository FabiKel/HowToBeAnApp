import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:htbah_app/app/creation_page/creation_page_focus.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/models/character.dart';

class CreationPageFirstStep extends StatelessWidget {
  final CreationPageFocusManager focusManager;
  final Character newChara;

  const CreationPageFirstStep(this.newChara, this.focusManager, {super.key});

  @override
  Widget build(BuildContext context) {
    final scrController = ScrollController();

    Future<void> jumpWAni(FocusNode node) async {
      scrController.animateTo(
        scrController.offset + 50,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
      await Future.delayed(const Duration(milliseconds: 260));
      node.nextFocus();
    }

    final items = [
      TextFormField(
        focusNode: focusManager.name,
        decoration: const InputDecoration(label: Text("Name*")),
        controller: TextEditingController(text: newChara.name),
        onChanged: (input) => newChara.name = input,
        onEditingComplete: () => focusManager.name.nextFocus(),
      ),
      TextFormField(
        focusNode: focusManager.gender,
        decoration: const InputDecoration(label: Text("Geschlecht")),
        controller: TextEditingController(text: newChara.gender),
        onChanged: (input) => newChara.gender = input,
        onEditingComplete: () => focusManager.gender.nextFocus(),
      ),
      TextFormField(
        focusNode: focusManager.age,
        decoration: const InputDecoration(label: Text("Alter")),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: TextEditingController(text: "${newChara.age}"),
        onChanged: (input) => newChara.age = int.tryParse(input) ?? 0,
        onEditingComplete: () => focusManager.age.nextFocus(),
      ),
      TextFormField(
        focusNode: focusManager.lpMax,
        decoration: const InputDecoration(label: Text("Max. LP")),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: TextEditingController(text: "${newChara.lpMax}"),
        onChanged: (input) => newChara.lpMax = int.tryParse(input) ?? 0,
        onEditingComplete: () => focusManager.lpMax.nextFocus(),
      ),
      TextFormField(
        focusNode: focusManager.body,
        decoration: const InputDecoration(label: Text("Statur")),
        controller: TextEditingController(text: newChara.body),
        onChanged: (input) => newChara.body = input,
        onEditingComplete: () async => await jumpWAni(focusManager.body),
      ),
      TextFormField(
        focusNode: focusManager.religion,
        decoration: const InputDecoration(label: Text("Religion")),
        controller: TextEditingController(text: newChara.religion),
        onChanged: (input) => newChara.religion = input,
        onEditingComplete: () async => await jumpWAni(focusManager.religion),
      ),
      TextFormField(
        focusNode: focusManager.profession,
        decoration: const InputDecoration(label: Text("Beruf")),
        controller: TextEditingController(text: newChara.profession),
        onChanged: (input) => newChara.profession = input,
        onEditingComplete: () async => await jumpWAni(focusManager.profession),
      ),
      TextFormField(
        focusNode: focusManager.family,
        decoration: const InputDecoration(label: Text("Familie")),
        controller: TextEditingController(text: newChara.family),
        onChanged: (input) => newChara.family = input,
        onEditingComplete: () => focusManager.family.nextFocus(),
      ),
    ];

    return DarkContainerBox(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        controller: scrController,
        itemCount: items.length,
        separatorBuilder: (c, i) => const SizedBox(height: 10),
        itemBuilder: (c, i) => items.elementAt(i),
      ),
    );
  }
}
