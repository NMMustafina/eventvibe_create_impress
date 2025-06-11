import 'dart:async';

import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/plaoutprov.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_update_plan_page.dart';

class Firs extends StatefulWidget {
  const Firs({super.key});

  @override
  State<Firs> createState() => _FirsState();
}

class _FirsState extends State<Firs> {
  @override
  Widget build(BuildContext context) {
    final plaoutProv = Provider.of<PlaOutProv>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: EvMotiBut(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUpdatePlanPage(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: ColorEv.blue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add plan',
                style: TextStyle(
                  color: ColorEv.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              const Icon(Icons.add, color: ColorEv.white),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Event plans',
          style: TextStyle(
            color: ColorEv.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              children: [
                if (plaoutProv.plaouts.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 150.0.h),
                    child: Column(
                      children: [
                        Center(child: Image.asset('assets/images/emp.png')),
                        SizedBox(height: 8.h),
                        Center(
                          child: Text(
                            "You don't have any upcoming events.",
                            style: TextStyle(
                              color: ColorEv.grey2,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => CadDatae(
                    plaoutProv: plaoutProv,
                    plaout: plaoutProv.plaouts[index],
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemCount: plaoutProv.plaouts.length,
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CadDatae extends StatefulWidget {
  const CadDatae({
    super.key,
    required this.plaoutProv,
    required this.plaout,
  });

  final PlaOutProv plaoutProv;
  final PlaOutModel plaout;

  @override
  State<CadDatae> createState() => _CadDataeState();
}

class _CadDataeState extends State<CadDatae> {
  late Timer? _tmr;
  late Duration _tmRmng;

  @override
  void initState() {
    super.initState();
    _clcTmRmng();
    _strtTmr();
  }

  @override
  void dispose() {
    _tmr?.cancel();
    super.dispose();
  }

  void _clcTmRmng() {
    final nw = DateTime.now();
    final ddln = widget.plaout.plaoutDadline;

    if (ddln.isAfter(nw)) {
      _tmRmng = ddln.difference(nw);
    } else {
      _tmRmng = Duration.zero;
    }

    setState(() {});
  }

  void _strtTmr() {
    _tmr = Timer.periodic(const Duration(seconds: 1), (tmr) {
      _clcTmRmng();
      if (_tmRmng == Duration.zero) {
        _tmr?.cancel();
      }
    });
  }

  String get _frmtdTmRmng {
    if (_tmRmng == Duration.zero) {
      return "Deadline passed";
    }

    final dys = _tmRmng.inDays;
    final hrs = _tmRmng.inHours.remainder(24);
    final mnts = _tmRmng.inMinutes.remainder(60);

    if (dys > 0) {
      return "$dys day${dys > 1 ? 's' : ''} left";
    } else if (hrs > 0) {
      return "$hrs hour${hrs > 1 ? 's' : ''} left";
    } else {
      return "$mnts minute${mnts > 1 ? 's' : ''} left";
    }
  }

  @override
  Widget build(BuildContext context) {
    return EvMotiBut(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddUpdatePlanPage(
              existingPlan: widget.plaout,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ColorEv.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: ColorEv.black.withOpacity(0.1),
              blurRadius: 10.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.plaout.plaoutName,
              style: TextStyle(
                color: ColorEv.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/12.svg',
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  DateFormat('MMMM dd, hh:mm').format(
                    widget.plaout.plaoutDate,
                  ),
                  style: TextStyle(
                    color: ColorEv.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/13.svg',
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.plaout.plaoutLocation,
                  style: TextStyle(
                    color: ColorEv.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(
              color: ColorEv.grey,
              height: 1.h,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/14.svg',
                  width: 20.w,
                  height: 20.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  _frmtdTmRmng,
                  style: TextStyle(
                    color: ColorEv.blue,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final itm = widget.plaout.listPlaoutChkList[index];
                  return Row(
                    children: [
                      EvMotiBut(
                        onPressed: () {
                          widget.plaoutProv.savePlaout(
                            widget.plaout.copyWith(
                              listPlaoutChkList: [
                                ...widget.plaout.listPlaoutChkList
                                    .map((e) => e.copyWith(
                                          isplaoutChkReady:
                                              !itm.isplaoutChkReady,
                                        )),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          itm.isplaoutChkReady
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: itm.isplaoutChkReady
                              ? ColorEv.blue
                              : ColorEv.black,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          itm.plaoutChkName,
                          style: TextStyle(
                            color: ColorEv.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: widget.plaout.listPlaoutChkList.length),
            SizedBox(height: 10.h),
            COlgeImg(images: widget.plaout.plaoutImage),
          ],
        ),
      ),
    );
  }
}

class COlgeImg extends StatelessWidget {
  final List<String> images;

  const COlgeImg({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final count = images.length;

    Widget imageWidget(String asset, {BoxFit fit = BoxFit.cover}) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(asset, fit: fit),
      );
    }

    if (count == 0) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (count >= 1)
          GridTile(
            child: imageWidget(images[0]),
          ),
        if (count >= 2)
          GridTile(
            child: imageWidget(images[1]),
          ),
        if (count >= 3)
          GridTile(
            child: imageWidget(images[2]),
          ),
        if (count == 4)
          GridTile(
            child: imageWidget(images[3]),
          ),
        if (count == 5)
          Column(
            children: [
              Expanded(
                child: imageWidget(images[3]),
              ),
              SizedBox(height: 4.h),
              Expanded(
                child: imageWidget(images[4]),
              ),
            ],
          ),
      ],
    );
  }
}
