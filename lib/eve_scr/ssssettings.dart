import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/dok_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/pro_ev.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Ssssettings extends StatelessWidget {
  const Ssssettings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(
            color: ColorEv.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            S(
                onPressed: () {
                  lauchUrl(context, DokEv.priPoli);
                },
                t: 'Privacy Policy'),
            S(
                onPressed: () {
                  lauchUrl(context, DokEv.terOfUse);
                },
                t: 'Terms of Use'),
            S(
                onPressed: () {
                  lauchUrl(context, DokEv.suprF);
                },
                t: 'Support'),
          ],
        ),
      ),
    );
  }
}

class S extends StatelessWidget {
  const S({
    super.key,
    required this.onPressed,
    required this.t,
  });
  final Function() onPressed;

  final String t;

  @override
  Widget build(BuildContext context) {
    return EvMotiBut(
      onPressed: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorEv.white,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              t,
              style: TextStyle(
                color: ColorEv.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 1.sp,
              ),
            ),

            // const Spacer(),
            // const Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   color: ColorT.white,
            //   size: 28,
            // ),
            // const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
