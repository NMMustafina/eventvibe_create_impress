import 'dart:io';

import 'package:eventvibe_create_impress_225_a/screens/photo_gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollageView extends StatelessWidget {
  final List<String> imagePaths;
  final double spacing;

  const CollageView({
    super.key,
    required this.imagePaths,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    final count = imagePaths.length;
    if (count == 3) return _buildThree(context);
    if (count == 4) return _buildFour(context);
    if (count == 5) return _buildFive(context);
    return const SizedBox();
  }

  Widget _buildImage(String path, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PhotoGalleryPage(
              imagePaths: imagePaths,
              initialIndex: index,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildThree(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildImage(imagePaths[0], 0, context),
        ),
        SizedBox(width: spacing.w),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(child: _buildImage(imagePaths[1], 1, context)),
              SizedBox(height: spacing.h),
              Expanded(child: _buildImage(imagePaths[2], 2, context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFour(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImage(imagePaths[0], 0, context)),
              SizedBox(width: spacing.w),
              Expanded(child: _buildImage(imagePaths[1], 1, context)),
            ],
          ),
        ),
        SizedBox(height: spacing.h),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImage(imagePaths[2], 2, context)),
              SizedBox(width: spacing.w),
              Expanded(child: _buildImage(imagePaths[3], 3, context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFive(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildImage(imagePaths[0], 0, context),
              ),
              SizedBox(width: spacing.w),
              Expanded(
                flex: 2,
                child: _buildImage(imagePaths[2], 2, context),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.h),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildImage(imagePaths[1], 1, context),
              ),
              SizedBox(width: spacing.w),
              Expanded(
                flex: 1,
                child: _buildImage(imagePaths[3], 3, context),
              ),
              SizedBox(width: spacing.w),
              Expanded(
                flex: 1,
                child: _buildImage(imagePaths[4], 4, context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
