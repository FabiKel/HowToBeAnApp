import 'package:flutter/material.dart';
import 'package:htbah_app/app/notes_page/note_page.dart';
import 'package:htbah_app/app/notes_page/notes_page.dart';
import 'package:htbah_app/app/widgets/design/dark_container_box.dart';
import 'package:htbah_app/models/character.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NotesOverview extends StatefulWidget {
  final Character chara;

  const NotesOverview(this.chara, {super.key});

  @override
  State<NotesOverview> createState() => _NotesOverviewState();
}

class _NotesOverviewState extends State<NotesOverview> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return DarkContainerBox(
      height: 150,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Notizen", style: TextStyle(fontSize: 18)),
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return NotesPage(widget.chara);
                    }),
                  ).then((value) => setState(() {}));
                },
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                _NotesOverviewPageView(widget.chara, pageController),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    // plus one for the "ADD" Widget
                    count: widget.chara.notes.length + 1,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: Colors.green,
                      dotColor: Colors.white24,
                      dotHeight: 5,
                      dotWidth: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesOverviewPageView extends StatefulWidget {
  final Character chara;
  final PageController pageController;

  const _NotesOverviewPageView(this.chara, this.pageController, {super.key});

  @override
  State<_NotesOverviewPageView> createState() => _NotesOverviewPageViewState();
}

class _NotesOverviewPageViewState extends State<_NotesOverviewPageView> {
  int pageIndex = 0;

  List<Widget> getNotes() {
    return widget.chara.notes.map((note) {
      return InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(chara: widget.chara, note: note),
            ),
          ).then((value) => setState(() {}));
        },
        borderRadius: BorderRadius.circular(5),
        child: Text("${note.title}\n${note.text}"),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      onPageChanged: (index) => setState(() {
        pageIndex = index;
      }),
      children: [
        ...getNotes(),
        InkWell(
          onTap: () async {
            final added = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(chara: widget.chara),
              ),
            );
            if (!added) return;
            setState(() {
              widget.pageController.jumpToPage(pageIndex);
            });
          },
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Icon(Icons.add, size: 60, color: Colors.white10),
            ),
          ),
        ),
      ],
    );
  }
}
