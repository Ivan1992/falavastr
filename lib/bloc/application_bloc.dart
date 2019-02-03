import 'dart:async';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:rxdart/rxdart.dart';


class ApplicationBloc implements BlocBase {

  DayText _dayText;
  
  BehaviorSubject<DayText> _dayTextController = BehaviorSubject<DayText>();
  Sink<DayText> get _inDayTextController => _dayTextController.sink;
  Stream<DayText> get outDayTextController => _dayTextController.stream;


  ApplicationBloc() {
    DayTextService.getDayText(DateTime.now(), TEXTTYPE.SVYATCY).then( (day) => _dayText = day);
    _inDayTextController.add(_dayText);
  }

  void dispose(){
    _dayTextController.close();
  }
 
}