import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:eventvibe_create_impress_225_a/models/album_model.dart';
import 'package:eventvibe_create_impress_225_a/screens/outfit_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../eve/plaoutprov.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddUpdatePlanPage extends StatefulWidget {
  final PlaOutModel? existingPlan;

  const AddUpdatePlanPage({Key? key, this.existingPlan}) : super(key: key);

  @override
  _AddUpdatePlanPageState createState() => _AddUpdatePlanPageState();
}

class _AddUpdatePlanPageState extends State<AddUpdatePlanPage> {
  final _frmKy = GlobalKey<FormState>();
  final _nmCntrlr = TextEditingController();
  final _dtCntrlr = TextEditingController();
  final _ddlnCntrlr = TextEditingController();
  final _lctnCntrlr = TextEditingController();
  final _chkLstCntrlr = TextEditingController();
  List<String> _slctdImgs = [];
  DateTime? _slctdDt;
  DateTime? _slctdDdln;
  bool _ntfctns = false;
  List<PlaoutChkList> _chkLst = [];
  int _nxtChkId = 1;

  final List<String> _predefinedChecklistItems = [
    'Iron the clothes',
    'Do hair',
    'Buy accessories',
    'Check tickets',
    'Check the balance on the card',
    'Charge your phone',
    'Print invitation',
    'Check dress code',
    'Charge gadgets',
    'Prepare speech',
    'Take cash',
    'Make a reservation',
    'Pack first aid kit',
    'Take a light snack',
    'Check the locks on the house',
  ];

  String _predefinedItem = 'Iron the clothes';

  @override
  void initState() {
    super.initState();
    if (widget.existingPlan != null) {
      _nmCntrlr.text = widget.existingPlan!.plaoutName;
      _lctnCntrlr.text = widget.existingPlan!.plaoutLocation;
      _slctdImgs = List.from(widget.existingPlan!.plaoutImage);
      _slctdDt = widget.existingPlan!.plaoutDate;
      _dtCntrlr.text = DateFormat('MMMM yyyy, HH:mm')
          .format(widget.existingPlan!.plaoutDate);
      _ddlnCntrlr.text = DateFormat('MMMM yyyy, HH:mm')
          .format(widget.existingPlan!.plaoutDadline);
      _slctdDdln = widget.existingPlan!.plaoutDadline;
      _ntfctns = widget.existingPlan!.isplaoutNotifi;
      _chkLst = List.from(widget.existingPlan!.listPlaoutChkList);
      _nxtChkId = _chkLst.isEmpty ? 1 : _chkLst.last.plaoutChkid + 1;
    }
  }

  bool get isNNeeded =>
      _nmCntrlr.text.trim().isNotEmpty &&
      _slctdDt != null &&
      _lctnCntrlr.text.trim().isNotEmpty &&
      _slctdDdln != null;

  void _addChkLstItm() {
    if (_chkLstCntrlr.text.isNotEmpty) {
      final gdf = _predefinedChecklistItems;
      gdf.shuffle();
      _predefinedItem = gdf.first;
      setState(() {
        _chkLst.add(PlaoutChkList(
          plaoutChkid: _nxtChkId++,
          plaoutChkName: _chkLstCntrlr.text,
          isplaoutChkReady: false,
        ));
        _chkLstCntrlr.clear();
      });
    }
  }

  Future<void> _svPln() async {
    if (isNNeeded) {
      final ploutPrv = Provider.of<PlaOutProv>(context, listen: false);
      final nwPln = PlaOutModel(
        plaoutid: widget.existingPlan?.plaoutid ??
            DateTime.now().millisecondsSinceEpoch,
        plaoutName: _nmCntrlr.text,
        plaoutImage: _slctdImgs,
        plaoutDate: _slctdDt!,
        plaoutLocation: _lctnCntrlr.text,
        listPlaoutChkList: _chkLst,
        plaoutDadline: _slctdDdln!,
        isplaoutNotifi: _ntfctns,
      );
      await ploutPrv.savePlaout(nwPln);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorEv.white,
        actions: [
          if (widget.existingPlan != null)
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: ColorEv.grey3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  builder: (context) => Container(
                    padding: EdgeInsets.all(16.r),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: ColorEv.grey2,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            margin: EdgeInsets.only(bottom: 16.h),
                          ),
                          Row(
                            children: [
                              SizedBox(width: 16.w),
                              const Spacer(),
                              Text(
                                'Delete plan?',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorEv.black,
                                ),
                              ),
                              const Spacer(),
                              EvMotiBut(
                                onPressed: () => Navigator.pop(context),
                                child: Icon(
                                  CupertinoIcons.clear,
                                  color: ColorEv.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            'Do you really want to delete the event plan? You will not be able to restore the plan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorEv.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EvMotiBut(
                                  onPressed: () => Navigator.pop(context),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: ColorEv.blue),
                                      color: ColorEv.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 20.w),
                              EvMotiBut(
                                  onPressed: () {
                                    final ploutPrv = Provider.of<PlaOutProv>(
                                        context,
                                        listen: false);
                                    ploutPrv.deletePlaout(
                                        widget.existingPlan!.plaoutid);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: ColorEv.white,
                                      border: Border.all(color: ColorEv.blue),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(CupertinoIcons.trash, color: Colors.black),
            ),
        ],
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/entrance_line.svg',
            width: 20.w,
            height: 20.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Text(
          'New plan',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: ColorEv.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _frmKy,
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              Text(
                'Name*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
              ),
              SizedBox(height: 8.h),
              CupertinoTextField(
                controller: _nmCntrlr,
                placeholder: 'Plan name',
                placeholderStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.grey2,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
                decoration: BoxDecoration(
                  color: ColorEv.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'Match your look*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 160.w,
                decoration: BoxDecoration(
                  color: ColorEv.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _slctdImgs.isEmpty
                    ? InkWell(
                        onTap: () async {
                          final fdsfs = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ObjPif(
                                slctedImgs: _slctdImgs,
                              ),
                            ),
                          );

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Image.asset(
                          'assets/images/ffee.png',
                          width: 48.w,
                          height: 48.h,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5.w,
                          crossAxisSpacing: 4.w,
                          mainAxisSpacing: 4.h,
                          padding: EdgeInsets.all(8.r),
                          children: [
                            ..._slctdImgs.map((img) => Stack(
                                  children: [
                                    Positioned.fill(
                                        child: Image.file(File(img),
                                            fit: BoxFit.cover)),
                                    Positioned(
                                      top: 4.h,
                                      right: 4.w,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _slctdImgs.remove(img);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.r),
                                          decoration: BoxDecoration(
                                            color:
                                                ColorEv.grey3.withOpacity(0.68),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'assets/images/close.png',
                                            color: ColorEv.white,
                                            width: 12.w,
                                            height: 12.h,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            if (_slctdImgs.length < 5)
                              InkWell(
                                onTap: () async {
                                  final fdsfs = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ObjPif(
                                        slctedImgs: _slctdImgs,
                                      ),
                                    ),
                                  );
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.add_photo_alternate),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Date and time of the event*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
              ),
              SizedBox(height: 8.h),
              CupertinoTextField(
                controller: _dtCntrlr,
                readOnly: true,
                onTap: () async {
                  final dt = await showDatePicker(
                    context: context,
                    initialDate: _slctdDt ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (dt != null) {
                    final tm = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (tm != null) {
                      setState(() {
                        _slctdDt = DateTime(
                          dt.year,
                          dt.month,
                          dt.day,
                          tm.hour,
                          tm.minute,
                        );
                        _dtCntrlr.text =
                            DateFormat('MMMM yyyy, HH:mm').format(_slctdDt!);
                      });
                    }
                  }
                },
                placeholder: 'Date and time of the event',
                placeholderStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.grey2,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
                decoration: BoxDecoration(
                  color: ColorEv.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'Location*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
              ),
              SizedBox(height: 8.h),
              CupertinoTextField(
                controller: _lctnCntrlr,
                placeholder: 'Event location',
                placeholderStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.grey2,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
                decoration: BoxDecoration(
                  color: ColorEv.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    'Check list',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorEv.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.check_box_outline_blank_rounded,
                      color: Colors.black),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _chkLstCntrlr,
                      placeholder: _predefinedItem,
                      placeholderStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorEv.grey2,
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorEv.black,
                      ),
                      decoration: BoxDecoration(
                        color: ColorEv.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addChkLstItm,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ..._chkLst.map((itm) => Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              _chkLst.remove(itm);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorEv.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 12.w),
                      child: Row(
                        children: [
                          Text(
                            itm.plaoutChkName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorEv.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: 16.h),
              Text(
                'Deadline*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
              ),
              SizedBox(height: 8.h),
              CupertinoTextField(
                controller: _ddlnCntrlr,
                readOnly: true,
                onTap: () async {
                  final dt = await showDatePicker(
                    context: context,
                    initialDate: _slctdDt ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (dt != null) {
                    final tm = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (tm != null) {
                      setState(() {
                        _slctdDdln = DateTime(
                          dt.year,
                          dt.month,
                          dt.day,
                          tm.hour,
                          tm.minute,
                        );
                        _ddlnCntrlr.text =
                            DateFormat('MMMM yyyy, HH:mm').format(_slctdDdln!);
                      });
                    }
                  }
                },
                placeholder: 'Select deadline ',
                placeholderStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.grey2,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorEv.black,
                ),
                decoration: BoxDecoration(
                  color: ColorEv.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: ColorEv.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorEv.black,
                      ),
                    ),
                    CupertinoSwitch(
                      value: _ntfctns,
                      onChanged: (vl) {
                        setState(() {
                          _ntfctns = vl;
                        });
                      },
                      activeColor: ColorEv.blue,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              EvMotiBut(
                onPressed: () {
                  _svPln();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isNNeeded ? ColorEv.blue : ColorEv.grey2,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorEv.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nmCntrlr.dispose();
    _lctnCntrlr.dispose();
    _chkLstCntrlr.dispose();
    super.dispose();
  }
}

class ObjPif extends StatefulWidget {
  const ObjPif({super.key, required this.slctedImgs});
  final List<String> slctedImgs;

  @override
  State<ObjPif> createState() => _ObjPifState();
}

class _ObjPifState extends State<ObjPif> {
  late Box<Album> albumBox;

  @override
  void initState() {
    super.initState();
    albumBox = Hive.box<Album>('albumBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Outfits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/entrance_line.svg',
            width: 20.w,
            height: 20.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: ValueListenableBuilder(
          valueListenable: albumBox.listenable(),
          builder: (context, Box<Album> box, _) {
            if (box.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/dress.png',
                      fit: BoxFit.cover,
                      width: 116.w,
                      height: 116.h,
                    ),
                    Text(
                      'You haven\'t added any outfits yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return GridView.builder(
                itemCount: box.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final album = box.getAt(index);
                  if (album == null) return Container();
                  return EvMotiBut(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OutfitDetailsScreen(
                            album: album,
                            isFirst: true,
                            slctedImages: widget.slctedImgs,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: ColorEv.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.h),
                                    child: album.imagePaths.isNotEmpty
                                        ? Image.asset(
                                            album.imagePaths.first,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Image.asset(
                                              'assets/images/dress.png',
                                              width: 46.w,
                                              height: 46.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Text(
                                    album.name,
                                    style: TextStyle(
                                      color: ColorEv.black.withOpacity(0.9),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (album.imagePaths.length > 1)
                            Positioned(
                              right: 8.w,
                              top: 8.h,
                              child: Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: ColorEv.grey4.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${album.imagePaths.length}',
                                  style: TextStyle(
                                    color: ColorEv.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
