import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve_scr/firs.dart';
import 'package:eventvibe_create_impress_225_a/eve_scr/outfits.dart';
import 'package:eventvibe_create_impress_225_a/eve_scr/ssssettings.dart';
import 'package:eventvibe_create_impress_225_a/screens/collage_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<CollageOverviewPageState> collageKey =
    GlobalKey<CollageOverviewPageState>();

class EvBotomBar extends StatefulWidget {
  const EvBotomBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<EvBotomBar> createState() => EvBotomBarState();
}

class EvBotomBarState extends State<EvBotomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  final _pages = <Widget>[
    const Firs(),
    const Outfits(),
    CollageOverviewPage(key: collageKey),
    const Ssssettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 110.h,
        width: double.infinity,
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
        decoration: const BoxDecoration(color: ColorEv.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: buildNavItem(0, 'assets/icons/1.png', 'Home')),
            Expanded(child: buildNavItem(1, 'assets/icons/2.png', 'Checkroom')),
            Expanded(child: buildNavItem(2, 'assets/icons/3.png', 'Combos')),
            Expanded(child: buildNavItem(3, 'assets/icons/4.png', 'Settings')),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath, String label) {
    final isActive = _currentIndex == index;

    return EvMotiBut(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });

        if (index == 2) {
          collageKey.currentState?.checkAndGenerateIfNeeded();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 26.w,
            height: 26.h,
            color: isActive ? null : ColorEv.grey2,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isActive ? ColorEv.blue : ColorEv.grey2,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 1.sp,
            ),
          ),
        ],
      ),
    );
  }
}
