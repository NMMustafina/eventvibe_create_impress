import 'package:eventvibe_create_impress_225_a/models/collage_card.dart';
import 'package:eventvibe_create_impress_225_a/screens/collage_reference_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../eve/color_ev.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Box<CollageCard> collageBox;

  @override
  void initState() {
    super.initState();
    collageBox = Hive.box<CollageCard>('collageBox');
  }

  @override
  Widget build(BuildContext context) {
    final favorites = collageBox.values.where((c) => c.isFavorite).toList();

    return Scaffold(
      backgroundColor: ColorEv.grey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorEv.white,
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
            'Favorites references',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/magic.svg',
                    width: 100.w,
                    height: 100.h,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      color: ColorEv.grey2,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final card = favorites[index];
                return SizedBox(
                    height: 520.h,
                    child: CollageReferenceCard(
                      card: card,
                      onToggleFavorite: () async {
                        card.isFavorite = false;
                        await card.save();
                        setState(() {});
                      },
                    ));
              },
            ),
    );
  }
}
