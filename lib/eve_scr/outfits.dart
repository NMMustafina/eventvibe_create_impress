import 'dart:io';

import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/moti_ev.dart';
import 'package:eventvibe_create_impress_225_a/models/album_model.dart';
import 'package:eventvibe_create_impress_225_a/screens/outfit_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Outfits extends StatefulWidget {
  const Outfits({super.key});

  @override
  State<Outfits> createState() => _OutfitsState();
}

class _OutfitsState extends State<Outfits> {
  late Box<Album> albumBox;

  @override
  void initState() {
    super.initState();
    albumBox = Hive.box<Album>('albumBox');
  }

  Future<void> _showAddAlbumDialog(BuildContext context) async {
    String albumName = '';
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              Text(
                'New outfit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
            ],
          ),
          content: CupertinoTextField(
            placeholder: 'Name',
            maxLength: 25,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            onChanged: (value) {
              albumName = value;
            },
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: ColorEv.black,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
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
                if (albumName.isNotEmpty) {
                  _addAlbum(albumName);
                  Navigator.pop(context);
                }
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

  void _addAlbum(String albumName) {
    final newAlbum = Album(name: albumName, imagePaths: []);
    albumBox.add(newAlbum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: EvMotiBut(
        onPressed: () {
          _showAddAlbumDialog(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 16.h),
          decoration: BoxDecoration(
            color: ColorEv.blue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a match',
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
      ),
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
                          builder: (_) => OutfitDetailsScreen(album: album),
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
                                        ? Image.file(
                                            File(album.imagePaths.first),
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
