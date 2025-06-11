import 'package:eventvibe_create_impress_225_a/eve/botbar_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvOnBoDi extends StatefulWidget {
  const EvOnBoDi({super.key});

  @override
  State<EvOnBoDi> createState() => _EvOnBoDiState();
}

class _EvOnBoDiState extends State<EvOnBoDi> {
  final PageController _controller = PageController();
  int introIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorEv.blue,
      body: Stack(
        children: [
          SizedBox(
            height: 730.h,
            child: PageView.builder(
              physics: const ClampingScrollPhysics(),
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  introIndex = index;
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return OnWid(
                  image: '${index + 1}',
                  tt: index == 0
                      ? 'Make your own plan\nwith an outfit'
                      : index == 1
                          ? 'Create your\nown outfits'
                          : 'Pick your favorite\noutfit sets',
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 115.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/${introIndex == 0 ? 1 : introIndex == 1 ? 2 : 3}.png',
                  height: 12.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 700.h),
            child: EvMotiBut(
              onPressed: () {
                if (introIndex != 2) {
                  _controller.animateToPage(
                    introIndex + 1,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EvBotomBar(),
                    ),
                    (protected) => false,
                  );
                }
              },
              child: Container(
                height: 55,
                margin: const EdgeInsets.only(right: 24, left: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorEv.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: ColorEv.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        height: 1.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnWid extends StatelessWidget {
  const OnWid({
    super.key,
    required this.image,
    required this.tt,
  });
  final String image;
  final String tt;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            tt,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorEv.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w400,
              height: 1.sp,
            ),
          ),
          SizedBox(height: 45.h),
          Image.asset(
            'assets/images/on$image.png',
            height: 530.h,
            // width: 276.83.w,
            fit: BoxFit.cover,
            // alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
