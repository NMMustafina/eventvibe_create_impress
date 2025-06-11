import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlaoutChkList {
  final int plaoutChkid;
  final String plaoutChkName;
  final bool isplaoutChkReady;

  PlaoutChkList(
      {required this.plaoutChkid,
      required this.plaoutChkName,
      required this.isplaoutChkReady});

  Map<String, dynamic> toMap() {
    return {
      'plaoutChkid': plaoutChkid,
      'plaoutChkName': plaoutChkName,
      'isplaoutChkReady': isplaoutChkReady,
    };
  }

  factory PlaoutChkList.fromMap(Map<String, dynamic> map) {
    return PlaoutChkList(
      plaoutChkid: map['plaoutChkid'],
      plaoutChkName: map['plaoutChkName'],
      isplaoutChkReady: map['isplaoutChkReady'],
    );
  }
  PlaoutChkList copyWith(
      {int? plaoutChkid, String? plaoutChkName, bool? isplaoutChkReady}) {
    return PlaoutChkList(
        plaoutChkid: plaoutChkid ?? this.plaoutChkid,
        plaoutChkName: plaoutChkName ?? this.plaoutChkName,
        isplaoutChkReady: isplaoutChkReady ?? this.isplaoutChkReady);
  }
}

class PlaOutModel {
  final int plaoutid;
  final String plaoutName;
  final List<String> plaoutImage;
  final DateTime plaoutDate;
  final String plaoutLocation;
  final List<PlaoutChkList> listPlaoutChkList;
  final DateTime plaoutDadline;
  final bool isplaoutNotifi;

  PlaOutModel(
      {required this.plaoutid,
      required this.plaoutName,
      required this.plaoutImage,
      required this.plaoutDate,
      required this.plaoutLocation,
      required this.listPlaoutChkList,
      required this.plaoutDadline,
      required this.isplaoutNotifi});

  Map<String, dynamic> toMap() {
    return {
      'plaoutid': plaoutid,
      'plaoutName': plaoutName,
      'plaoutImage': plaoutImage,
      'plaoutDate': plaoutDate.toIso8601String(),
      'plaoutLocation': plaoutLocation,
      'listPlaoutChkList': listPlaoutChkList.map((x) => x.toMap()).toList(),
      'plaoutDadline': plaoutDadline.toIso8601String(),
      'isplaoutNotifi': isplaoutNotifi,
    };
  }

  factory PlaOutModel.fromMap(Map<String, dynamic> map) {
    return PlaOutModel(
      plaoutid: map['plaoutid'],
      plaoutName: map['plaoutName'],
      plaoutImage: List<String>.from(map['plaoutImage']),
      plaoutDate: DateTime.parse(map['plaoutDate']),
      plaoutLocation: map['plaoutLocation'],
      listPlaoutChkList: List<PlaoutChkList>.from(
          map['listPlaoutChkList']?.map((x) => PlaoutChkList.fromMap(x))),
      plaoutDadline: DateTime.parse(map['plaoutDadline']),
      isplaoutNotifi: map['isplaoutNotifi'],
    );
  }
  PlaOutModel copyWith(
      {int? plaoutid,
      String? plaoutName,
      List<String>? plaoutImage,
      DateTime? plaoutDate,
      String? plaoutLocation,
      List<PlaoutChkList>? listPlaoutChkList,
      DateTime? plaoutDadline,
      bool? isplaoutNotifi}) {
    return PlaOutModel(
        plaoutid: plaoutid ?? this.plaoutid,
        plaoutName: plaoutName ?? this.plaoutName,
        plaoutImage: plaoutImage ?? this.plaoutImage,
        plaoutDate: plaoutDate ?? this.plaoutDate,
        plaoutLocation: plaoutLocation ?? this.plaoutLocation,
        listPlaoutChkList: listPlaoutChkList ?? this.listPlaoutChkList,
        plaoutDadline: plaoutDadline ?? this.plaoutDadline,
        isplaoutNotifi: isplaoutNotifi ?? this.isplaoutNotifi);
  }
}

class PlaOutProv with ChangeNotifier {
  List<PlaOutModel> _plaouts = [];
  static const String _storageKey = 'plaout_data';

  List<PlaOutModel> get plaouts => _plaouts;

  PlaOutProv() {
    _loadPlaouts();
  }

  Future<void> _loadPlaouts() async {
    final kkkjkjbn = await SharedPreferences.getInstance();
    final String? plaoutString = kkkjkjbn.getString(_storageKey);

    if (plaoutString != null) {
      final List<dynamic> decodedData = json.decode(plaoutString);
      _plaouts = decodedData.map((item) => PlaOutModel.fromMap(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _savePlaouts() async {
    final kkkjkjbn = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _plaouts.map((item) => item.toMap()).toList(),
    );
    await kkkjkjbn.setString(_storageKey, encodedData);
  }

  Future<void> savePlaout(PlaOutModel plaout) async {
    final index = _plaouts.indexWhere((p) => p.plaoutid == plaout.plaoutid);
    if (index != -1) {
      _plaouts[index] = plaout;
    } else {
      _plaouts.add(plaout);
    }
    await _savePlaouts();
    notifyListeners();
  }

  Future<void> deletePlaout(int plaoutId) async {
    _plaouts.removeWhere((p) => p.plaoutid == plaoutId);
    await _savePlaouts();
    notifyListeners();
  }

  PlaOutModel? getPlaoutById(int plaoutId) {
    try {
      return _plaouts.firstWhere((p) => p.plaoutid == plaoutId);
    } catch (e) {
      return null;
    }
  }
}
