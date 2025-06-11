import 'package:eventvibe_create_impress_225_a/models/collage_card.dart';
import 'package:eventvibe_create_impress_225_a/screens/collage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CollageReferenceCard extends StatelessWidget {
  final CollageCard card;
  final VoidCallback onToggleFavorite;

  const CollageReferenceCard({
    super.key,
    required this.card,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final index = card.key as int? ?? 0;
    final bgImage = _backgroundImageFor(index % 3);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: card.imagePaths.isNotEmpty
                    ? CollageView(imagePaths: card.imagePaths)
                    : const Center(child: Text('No images available')),
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: GestureDetector(
                onTap: onToggleFavorite,
                child: Container(
                  width: 64.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4E1F8),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      card.isFavorite
                          ? 'assets/icons/star_filled.svg'
                          : 'assets/icons/star_outline.svg',
                      width: 32.w,
                      height: 32.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _backgroundImageFor(int index) {
    switch (index) {
      case 0:
        return 'assets/images/bg1.png';
      case 1:
        return 'assets/images/bg2.png';
      case 2:
      default:
        return 'assets/images/bg3.png';
    }
  }
}
