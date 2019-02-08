import 'dart:async';
import 'dart:collection';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  List<DayText> _infoPage = [];

  BehaviorSubject<List<DayText>> _infoPageController =
      BehaviorSubject<List<DayText>>();
  StreamSink<List<DayText>> get _inInfoPage => _infoPageController.sink;
  Stream<List<DayText>> get outInfoPage => _infoPageController.stream;

  StreamController _changeDateController = StreamController();
  StreamSink get changeDate => _changeDateController.sink;

  StreamController _updateInfoPage = StreamController();
  StreamSink get updateInfoPage => _updateInfoPage.sink;

  ApplicationBloc() {
    _apiInfoDay().then((_) {
      print("FINISHED");
      _inInfoPage.add(UnmodifiableListView(_infoPage));
    });
    /* DayTextService.getDayText(DateTime.now(), TEXTTYPE.SVYATCY).then((day) {
      _infoPage.add(day);
    }); */

    /* _infoPage.forEach((x) {
      print(">>>>>>>>${x.title}");
    }); */
    _changeDateController.stream.listen(_handeChangeDate);
    _updateInfoPage.stream.listen(_handleUpdateInfoPage);
  }

  _handleUpdateInfoPage(_) async {
    await _apiInfoDay();
  }

  Future<Null> _apiInfoDay() async {
    //_infoPage = [];
    for (var i=0; i < TEXTTYPE.values.length; i++) {
      _infoPage.add(await DayTextService.getDayText(DateTime.now(), TEXTTYPE.values[i]));
    }
    TEXTTYPE.values.forEach((type) async {
      await DayTextService.getDayText(DateTime.now(), type).then( (day) => _infoPage.add(day));
    });
    _inInfoPage.add(UnmodifiableListView(_infoPage));
  }

  _handeChangeDate(data) {
    _infoPage = [];
    TEXTTYPE.values.forEach((type) {
      DayTextService.getDayText(data, type).then((day) => _infoPage.add(day));
    });
    _inInfoPage.add(UnmodifiableListView(_infoPage));
  }

  void dispose() {
    _infoPageController.close();
    _changeDateController.close();
    _updateInfoPage.close();
  }
}
