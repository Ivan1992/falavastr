import 'dart:async';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';

class LibraryBloc implements BlocBase {
  StreamController<List<DayText>> _libraryListController =
      StreamController<List<DayText>>();
  Stream<List<DayText>> get outLibraryList => _libraryListController.stream;

  StreamController<BOOKTYPE> _switchBookController =
      StreamController<BOOKTYPE>();
  Sink<BOOKTYPE> get inSwitchBook => _switchBookController.sink;

  LibraryBloc() {
    _switchBookController.stream.listen(_handleSwitchBook);
  }

  _handleSwitchBook(value) async {
    List<DayText> dayText;
    if (value == BOOKTYPE.APOSTOL) {
      dayText = await DayTextService.getBookByType(value);
    } else if (value == BOOKTYPE.EVANGELIE) {
      dayText = await DayTextService.getBookByType(value);
    } else if (value == BOOKTYPE.PSALMS) {
      dayText = await DayTextService.getBookByType(value);
    } else if (value == BOOKTYPE.CHASOSLOV) {

    }

    _libraryListController.sink.add(dayText);
  }

  void dispose() {
    _libraryListController.close();
    _switchBookController.close();
  }
}
