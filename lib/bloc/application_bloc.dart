import 'dart:async';
import 'dart:collection';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc implements BlocBase {
  List<DayText> _infoPage = [];

  BehaviorSubject<List<DayText>> _infoPageController =
      BehaviorSubject<List<DayText>>();
  StreamSink<List<DayText>> get _inInfoPage => _infoPageController.sink;
  Stream<List<DayText>> get outInfoPage => _infoPageController.stream;

  BehaviorSubject<List<DayText>> _canonsListConteroller =  BehaviorSubject<List<DayText>>();
  Stream<List<DayText>> get outCanonsList => _canonsListConteroller.stream;

  StreamController _changeDateController = StreamController();
  StreamSink get changeDate => _changeDateController.sink;

  StreamController _updateInfoPage = StreamController();
  StreamSink get updateInfoPage => _updateInfoPage.sink;

  BehaviorSubject<String> _fontFamilyController = BehaviorSubject<String>(seedValue: "Grebnev");
  Stream<String> get outFontFamily => _fontFamilyController.stream;
  StreamSink<String> get inFontFamily => _fontFamilyController.sink;

  BehaviorSubject<bool> _newStyleController = BehaviorSubject<bool>(seedValue: true);
  Stream<bool> get outNewStyle => _newStyleController.stream;
  StreamSink<bool> get inNewStyle => _newStyleController.sink;

  ApplicationBloc() {
    _apiInfoDay();
    _changeDateController.stream.listen(_handeChangeDate);
    _updateInfoPage.stream.listen(_handleUpdateInfoPage);
    outFontFamily.listen(_handleChangeFont);
    outNewStyle.listen(_handleChangeNewStyle);
    _loadInitialPrefs();
    _loadCanonsList();
  }

  _handleChangeNewStyle(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("newStyle", value);
  }

  _handleChangeFont(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fontFamily", value);
  }

  _loadInitialPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    inFontFamily.add(prefs.getString("fontFamily") ?? 'Grebnev');
    inNewStyle.add(prefs.getBool("newStyle") ?? true);
  }

  _loadCanonsList() async {
    List<DayText> _canonsList = await DayTextService.getKanonnik();
    _canonsListConteroller.sink.add(_canonsList);
  }

  _handleUpdateInfoPage(_) async {
    await _apiInfoDay();
  }

  Future<Null> _apiInfoDay() async {
    _infoPage = [];
    for (var i = 0; i < TEXTTYPE.values.length; i++) {
      _infoPage.add(await DayTextService.getDayText(DateTime.now(), TEXTTYPE.values[i]));
    }

    _inInfoPage.add(UnmodifiableListView(_infoPage));
  }

  _handeChangeDate(data) async {
    _infoPage = [];
    for (var i = 0; i < TEXTTYPE.values.length; i++) {
      _infoPage.add(await DayTextService.getDayText(data, TEXTTYPE.values[i]));
    }
    _inInfoPage.add(UnmodifiableListView(_infoPage));
  }

  void dispose() {
    _infoPageController.close();
    _changeDateController.close();
    _updateInfoPage.close();
    _fontFamilyController.close();
    _newStyleController.close();
    _canonsListConteroller.close();
  }
}
