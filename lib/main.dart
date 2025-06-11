import 'package:eventvibe_create_impress_225_a/eve/color_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/onb_ev.dart';
import 'package:eventvibe_create_impress_225_a/eve/plaoutprov.dart';
import 'package:eventvibe_create_impress_225_a/models/album_model.dart';
import 'package:eventvibe_create_impress_225_a/models/collage_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AlbumAdapter());
  Hive.registerAdapter(CollageCardAdapter());

  await Hive.openBox<Album>('albumBox');
  await Hive.openBox<CollageCard>('collageBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaOutProv(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EventVibe',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: ColorEv.white,
            ),
            scaffoldBackgroundColor: ColorEv.grey,
            // fontFamily: '-_- ??',
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          navigatorObservers: [routeObserver],
          home: const EvOnBoDi(),
        ),
      ),
    );
  }
}
