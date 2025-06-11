import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Thre extends StatelessWidget {
  const Thre({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Outfit references',
          style: TextStyle(
            color: ColorEv.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}