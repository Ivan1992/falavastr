import 'DateService.dart';

class Event {
  final DateTime date;
  final String name;
  final int type;
  final bool movable;
  final int daysShift;

  DateTime getDate(int year) {
    if (!movable) return date;
    DateTime pasha = DateService.pasha(year);
    DateTime prazdnik;
    if (daysShift >= 0) {
      prazdnik = pasha.add(Duration(days: daysShift));
    } else {
      prazdnik = pasha.subtract(Duration(days: daysShift));
    }
    return prazdnik;
  }

  bool isSame(DateTime d, [type = -1]) {
    if (movable) {
      DateTime date = getDate(d.year);
      if (type > -1) {
        return d.day == date.day && d.month == date.month && this.type == type;
      } else {
        return d.day == date.day && d.month == date.month;
      }
    } else {
      if (type > -1) {
        return d.day == date.day && d.month == date.month && this.type == type;
      } else {
        return d.day == date.day && d.month == date.month;
      }
    }
  }

  bool thisMonth(DateTime d) {
    if (movable) {
      DateTime date = getDate(d.year);
      return d.month == date.month;
    } else {
      return d.month == date.month;
    }
  }

  const Event(
      {this.date,
      this.name,
      this.type,
      this.movable = false,
      this.daysShift = 0});
}
