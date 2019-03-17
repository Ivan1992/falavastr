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
    List<DayText> dayText = await DayTextService.getBookByType(value);
    _libraryListController.sink.add(dayText);
  }

  void dispose() {
    _libraryListController.close();
    _switchBookController.close();
  }
}
