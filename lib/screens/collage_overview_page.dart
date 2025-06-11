import 'dart:math';

import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/models/album_model.dart';
import 'package:eventvibe_create_impress_225_a/models/collage_card.dart';
import 'package:eventvibe_create_impress_225_a/screens/collage_reference_card.dart';
import 'package:eventvibe_create_impress_225_a/screens/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CollageOverviewPage extends StatefulWidget {
  const CollageOverviewPage({super.key});

  @override
  CollageOverviewPageState createState() => CollageOverviewPageState();
}

class CollageOverviewPageState extends State<CollageOverviewPage>
    with RouteAware {
  late Box<CollageCard> collageBox;
  List<CollageCard> visibleCards = [];

  final double cardHeight = 380;
  final double cardHeightExpanded = 520;
  late final PageController _controller;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    collageBox = Hive.box<CollageCard>('collageBox');

    const fraction = 0.661;
    _controller = PageController(
      initialPage: 0,
      viewportFraction: fraction,
    );

    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0.0;
      });
    });

    checkAndGenerateIfNeeded();
  }

  Future<void> checkAndGenerateIfNeeded() async {
    final today = DateTime.now();
    final hasTodayCollages = collageBox.values.any(
      (c) =>
          c.createdAt.year == today.year &&
          c.createdAt.month == today.month &&
          c.createdAt.day == today.day,
    );

    if (hasTodayCollages) {
      loadVisibleCards();
      return;
    }

    final albumBox = Hive.box<Album>('albumBox');
    final validAlbums =
        albumBox.values.where((a) => a.imagePaths.length >= 3).toList();

    if (validAlbums.length >= 3) {
      await resetAndRegenerateCollages();
    } else {
      setState(() {
        visibleCards = [];
      });
    }
  }

  Future<void> resetAndRegenerateCollages() async {
    final favorites = collageBox.values
        .where((c) => c.isFavorite && c.imagePaths.isNotEmpty)
        .toList();

    await collageBox.clear();

    final albumBox = Hive.box<Album>('albumBox');
    final validAlbums =
        albumBox.values.where((a) => a.imagePaths.length >= 3).toList();

    if (validAlbums.length < 3) {
      setState(() {
        visibleCards = [];
      });
      return;
    }

    const uuid = Uuid();
    final generated = <CollageCard>[];

    for (int i = 0; i < 3; i++) {
      final count = Random().nextInt(3) + 3;

      final allImages = validAlbums.expand((a) => a.imagePaths).toList()
        ..shuffle();
      final selected = allImages.take(count).toSet().toList();

      if (selected.length < 3) break;

      final collage = CollageCard(
        id: uuid.v4(),
        imagePaths: selected,
        title: 'Collage ${i + 1}',
        createdAt: DateTime.now(),
        isFavorite: false,
      );

      generated.add(collage);
    }

    final all = [...favorites, ...generated];
    for (final c in all) {
      await collageBox.add(c);
    }

    loadVisibleCards();
  }

  void loadVisibleCards() {
    final all = collageBox.values.toList();
    setState(() {
      visibleCards = all.where((card) => !card.isFavorite).toList();
    });
  }

  bool _hasTodayCollages() {
    final today = DateTime.now();
    return collageBox.values.any(
      (c) =>
          c.createdAt.year == today.year &&
          c.createdAt.month == today.month &&
          c.createdAt.day == today.day,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    loadVisibleCards();
  }

  void _toggleFavorite(CollageCard card) async {
    card.isFavorite = !card.isFavorite;
    await card.save();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorEv.grey,
      appBar: AppBar(
        backgroundColor: ColorEv.white,
        title: Text(
          'Outfit references',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/star_filled.svg',
              width: 24.w,
              height: 24.h,
              color: ColorEv.blue,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
              loadVisibleCards();
            },
          ),
        ],
      ),
      body: visibleCards.isEmpty
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
                    _hasTodayCollages()
                        ? 'All today\'s collages\nhave been saved to favorites.\nNew ones will be available tomorrow!'
                        : 'Not enough data to generate collages.\nAdd at least 3 outfits with 3+ photos each.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: PageView.builder(
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: visibleCards.length,
                itemBuilder: (context, index) {
                  final card = visibleCards[index];
                  final distance = (_currentPage - index).abs();
                  final scale = (1 - (distance * 0.1)).clamp(0.9, 1.0);
                  final height = cardHeight.h +
                      ((cardHeightExpanded - cardHeight) *
                          (1 - distance.clamp(0.0, 1.0)));

                  return Align(
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      child: SizedBox(
                        height: height,
                        child: CollageReferenceCard(
                          card: card,
                          onToggleFavorite: () => _toggleFavorite(card),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
