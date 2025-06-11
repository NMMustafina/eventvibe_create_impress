import 'dart:io';
import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eventvibe_create_impress_225_a/models/album_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class OutfitDetailsScreen extends StatefulWidget {
  final Album album;
  final bool isFirst;
  final List<String> slctedImages;

  const OutfitDetailsScreen({
    Key? key,
    required this.album,
    this.isFirst = false,
    this.slctedImages = const [],
  }) : super(key: key);

  @override
  _OutfitDetailsScreenState createState() => _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState extends State<OutfitDetailsScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _setdImages = [];

  Future<void> _addPhotos() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      if (widget.album.imagePaths.length + pickedFiles.length > 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can add a maximum of 15 photos')),
        );
        return;
      }
      setState(() {
        widget.album.imagePaths.addAll(pickedFiles.map((e) => e.path));
      });
      widget.album.save();
    }
  }

  void _removePhoto(int index) {
    setState(() {
      widget.album.imagePaths.removeAt(index);
    });
    widget.album.save();
  }

  Future<void> _showEditNameAlertDialog() async {
    final controller = TextEditingController(text: widget.album.name);

    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'Edit name',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            children: [
              SizedBox(height: 6.h),
              Text(
                'Name of the outfits',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 14.h),
              CupertinoTextField(
                controller: controller,
                maxLength: 25,
                placeholder: 'New name',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    widget.album.name = controller.text.trim();
                  });
                  widget.album.save();
                }
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmDeleteBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Delete album?',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: EvMotiBut(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 24.r,
                        color: ColorEv.blue,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 22.h),
              Text(
                "Do you really want to delete outfits? You won't be able to restore the added outfits",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EvMotiBut(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 27.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorEv.blue, width: 1.r),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: ColorEv.blue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  EvMotiBut(
                    onPressed: () {
                      widget.album.delete();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 27.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorEv.blue, width: 1.r),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showOptionsBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),
                  Container(
                    height: 5.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                      color: ColorEv.grey2,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 9.h, bottom: 22.h),
                    child: Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  EvMotiBut(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditNameAlertDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorEv.blue, width: 1.r),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Edit name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorEv.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  EvMotiBut(
                    onPressed: () {
                      Navigator.pop(context);
                      _showConfirmDeleteBottomSheet();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorEv.blue, width: 1.r),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Delete',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: EvMotiBut(
                      onPressed: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorEv.blue, width: 1.r),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorEv.blue,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _setdImages.addAll(widget.slctedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: widget.isFirst
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: widget.isFirst && _setdImages.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              margin: EdgeInsets.only(left: 20.h, right: 20.h),
              decoration: BoxDecoration(
                color: ColorEv.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EvMotiBut(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: ColorEv.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (_setdImages.length < 5)
                    Text(
                      'Selected ${_setdImages.length} item',
                      style: TextStyle(
                        color: ColorEv.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (_setdImages.length >= 5)
                    Text(
                      'Max 5',
                      style: TextStyle(
                        color: Color(0xFFE52424),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  EvMotiBut(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      widget.slctedImages.removeWhere(
                          (element) => _setdImages.contains(element));
                      widget.slctedImages.addAll(_setdImages);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ColorEv.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : widget.album.imagePaths.isEmpty
              ? EvMotiBut(
                  onPressed: _addPhotos,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.h, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: ColorEv.blue,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add a photo',
                          style: TextStyle(
                            color: ColorEv.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          'assets/icons/add.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/exit_to_app.svg',
            width: 24.w,
            height: 24.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.album.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: widget.isFirst
            ? []
            : [
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/add.svg',
                        color: ColorEv.black,
                        width: 24.w,
                        height: 24.h,
                      ),
                      onPressed: _addPhotos,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: ColorEv.black,
                        size: 24.r,
                      ),
                      onPressed: _showOptionsBottomSheet,
                    ),
                  ],
                )
              ],
      ),
      body: SafeArea(
        child: widget.album.imagePaths.isEmpty
            ? Center(
                child: Text(
                  'No photos yet',
                  style: TextStyle(
                    color: ColorEv.txt,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.h,
                ),
                itemCount: widget.album.imagePaths.length,
                itemBuilder: (context, index) {
                  final imagePath = widget.album.imagePaths[index];
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: EvMotiBut(
                          onPressed: () {
                            if (widget.isFirst) {
                              if (_setdImages.contains(imagePath)) {
                                setState(() {
                                  _setdImages.remove(imagePath);
                                });
                              } else {
                                setState(() {
                                  if (_setdImages.length < 5) {
                                    _setdImages.add(imagePath);
                                  }
                                });
                              }
                            }
                          },
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (!widget.isFirst)
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: InkWell(
                            onTap: () => _removePhoto(index),
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: ColorEv.grey3.withOpacity(0.68),
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
                      if (widget.isFirst && _setdImages.contains(imagePath))
                        Positioned(
                          bottom: 4.h,
                          right: 4.w,
                          child: SvgPicture.asset(
                            'assets/icons/che.svg',
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
