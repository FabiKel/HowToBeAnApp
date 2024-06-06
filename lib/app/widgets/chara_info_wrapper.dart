import 'package:flutter/material.dart';
import 'package:htbah_app/app/widgets/chara_description.dart';
import 'package:htbah_app/app/widgets/chara_info.dart';
import 'package:htbah_app/app/widgets/inventory_overview.dart';
import 'package:htbah_app/models/character.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CharaInfoWrapper extends StatefulWidget {
  final Character chara;

  const CharaInfoWrapper(this.chara, {super.key});

  @override
  State<CharaInfoWrapper> createState() => _CharaInfoWrapperState();
}

class _CharaInfoWrapperState extends State<CharaInfoWrapper> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black26,
        ),
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              children: [
                CharaInfo(widget.chara),
                CharaDescription(widget.chara),
                InventoryOverview(widget.chara),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: const SwapEffect(
                  type: SwapType.yRotation,
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
    );
  }
}
