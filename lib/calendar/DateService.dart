import 'package:date_utils/date_utils.dart';

import 'Event.dart';

class DateService {
  static DateTime pasha(int god) {
    var a = god % 19;
    var b = god % 4;
    var c = god % 7;
    var d = (19 * a + 15) % 30;
    var e = (2 * b + 4 * c + 6 * d + 6) % 7;
    var f = d + e;
    var noviyStil, easter;
    if (f <= 9) {
      easter = 22 + f;
      noviyStil = DateTime(god, 3, easter).add(Duration(days: 13));
    } else {
      easter = f - 9;
      noviyStil = DateTime(god, 4, easter).add(Duration(days: 13));
    }
    return noviyStil;
  }

  static String glasString(DateTime today) {
    return (["первыи","вторыи","третии","четвертыи","пятыи","шестыи","седьмыи","осьмыи"])[glas(today)-1];
  }

  static int glas(DateTime today) {
    int year = today.year;
    DateTime p = pasha(year);
    today = today.subtract(Duration(days: 7));
    if (today.isBefore(p)) {
      p = pasha(year - 1);
    }

    int r = (((today.millisecondsSinceEpoch - p.millisecondsSinceEpoch).abs()) / (7*24*60*60*1000)).round();
    return (r%8) + 1;
  }

  static bool isFastDay(DateTime d) {
    if (isPrazdnik(d, 0) || isPrazdnik(d, 1)) {
      return true;
    }

    DateTime p = pasha(d.year);

    //ПЕТРОВСКИЙ (АПОСТОЛЬСКИЙ) Пост
    DateTime start = p.add(Duration(days: 57));
    DateTime end = DateTime(d.year, 7, 12);
    if (d.compareTo(start) >= 0 && d.compareTo(end) <= 0 ) {
      return true;
    }

    //УСПЕНСКИЙ Пост
    start = DateTime(d.year, 8, 14);
    end = DateTime(d.year, 8, 27);
    if (d.compareTo(start) >= 0 && d.compareTo(end) <= 0 ) {
      return true;
    }

    //РОЖДЕСТВЕНСКИЙ Пост
    start = DateTime(d.year, 11, 29);
    end = DateTime(d.year, 1, 6);
    if (d.compareTo(start) >= 0 || d.compareTo(end) <= 0 ) {
      return true;
    }

    //ВЕЛИКИЙ Пост
    end = DateTime(p.year, p.month, p.day);
    start = end.subtract(Duration(days: 48));
    if (d.compareTo(start) >= 0 && d.compareTo(end) <= 0 ) {
      return true;
    }

    //СПЛОШНАЯ Седмица по РОЖДЕСТВЕ ХРИСТОВОМ
    start = DateTime(d.year, 1, 7);
    end = DateTime(d.year, 1, 17);
    if (d.compareTo(start) >= 0 && d.compareTo(end) <= 0 ) {
      return false;
    }

    //СПЛОШНАЯ Седмица по ПЯТИДЕСЯТНИЦЕ
    start = DateTime(p.year, p.month, p.day).add(Duration(days: 50));
    end = DateTime(p.year, p.month, p.day).add(Duration(days: 57));
    if (d.compareTo(start) >= 0 && d.compareTo(end) <= 0 ) {
      return false;
    }

    //ВОЗДВИЖЕНИЕ ЧЕСТНАГО КРЕСТА - Пост
    start = DateTime(d.year, 9, 27);
    if (start.day == d.day && start.month == d.month) {
      return true;
    }

    //УСЕКНОВЕНИЕ ГЛАВЫ СВ. ИОАННА ПРЕДОТЕЧИ - Пост
    start = DateTime(d.year, 9, 11);
    if (start.day == d.day && start.month == d.month) {
      return true;
    }

    //СРЕДА, ПЯТНИЦА
    if (d.weekday == DateTime.wednesday || d.weekday == DateTime.friday) {
      return true;
    }

    return false;
  }

  static bool isPrazdnik(DateTime d, int type) {
    return prazdniki.any((x) => x.isSame(d, type));
    /* bool b = prazdniki.any((x) => x.isSame(d));
    if (b) return true;
    if (type == 0) {

    } */
  }
}

List<Event> prazdniki = [
  Event(type: 0, name: "Вход Господень во Иеросалим", movable: true, daysShift: -7),
  Event(type: 0, name: "Пасха", movable: true, daysShift: 0),
  Event(type: 0, name: "Светлый понедельник", movable: true, daysShift: 1),
  Event(type: 0, name: "Светлый вторник", movable: true, daysShift: 2),
  Event(type: 0, name: "Светлая среда", movable: true, daysShift: 3),
  Event(type: 0, name: "Светлый четверг", movable: true, daysShift: 4),
  Event(type: 0, name: "Светлая пятница", movable: true, daysShift: 5),
  Event(type: 0, name: "Светлая суббота", movable: true, daysShift: 6),
  Event(type: 1, name: "Антипасха", movable: true, daysShift: 7),
  Event(type: 1, name: "Вознесение", movable: true, daysShift: 40),
  Event(type: 0, name: "Троица", movable: true, daysShift: 49),
  Event(date:DateTime(2018, 9, 21), type: 0, name: "Рождество Пресвятой Богородицы"),
  Event(date:DateTime(2018, 9, 27), type: 0, name: "Воздвижение Креста Господня"),
  Event(date:DateTime(2018, 12, 4), type: 0, name: "Введение во храм Пресвятой Богородицы"),
  Event(date:DateTime(2018, 1, 7), type: 0, name: "Рождество Христово"),
  Event(date:DateTime(2018, 1, 19), type: 0, name: "Крещение Господне (Богоявление)"),
  Event(date:DateTime(2018, 2, 15), type: 0, name: "Сретение Господне"),
  Event(date:DateTime(2018, 4, 7), type: 0, name: "Благовещение Пресвятой Богородицы"),
  Event(date:DateTime(2018, 8, 19), type: 0, name: "Преображение Господне"),
  Event(date:DateTime(2018, 8, 28), type: 0, name: "Успение Богородицы"),
  Event(date:DateTime(2018, 1, 14), type: 1, name: "Обрезание Господне"),
  Event(date:DateTime(2018, 7, 7), type: 1, name: "Рожество Иоанна Предотечи"),
  Event(date:DateTime(2018, 7, 12), type: 1, name: "День святых первоверховных апостолов Петра и Павла"),
  Event(date:DateTime(2018, 9, 11), type: 1, name: "Усекновение главы Иоанна Предотечи"),
  Event(date:DateTime(2018, 10, 14), type: 1, name: "Покров Пресвятой Богородицы"),
  Event(date:DateTime(2018, 7, 9), type: 2, name: "Празднование явления иконы Пресвятыя Богородицы Тихвинския"),
  Event(date:DateTime(2018, 9, 14), type: 2, name: "Начало Индикту, еже есть новому лету"),
  Event(date:DateTime(2018, 2, 12), type: 2, name: "Tрех святителей: Василия Великаго, Григория Богослова и Иоанна Златоустаго"),
  Event(date:DateTime(2018, 3, 22), type: 2, name: "Сорок мучеников Севастийских"),
  Event(date:DateTime(2018, 5, 6), type: 2, name: "Память влмч. Георгия Победоносца"),
  Event(date:DateTime(2018, 6, 3), type: 2, name: "Празднование сретению иконы Пресвятыя Богородицы Владимирския"),
  Event(date:DateTime(2018, 7, 9), type: 2, name: "Празднование явления иконы Пресвятыя Богородицы Тихвинския"),
  Event(date:DateTime(2018, 7, 15), type: 2, name: "Положение ризы Богородицы в Лахерне"),
  Event(date:DateTime(2018, 7, 21), type: 2, name: "Празднование явлению иконы Богородицы во граде Казани"),
  Event(date:DateTime(2018, 7, 22), type: 2, name: "Явление иконы Богородицы во граде Можайске"),
  Event(date:DateTime(2018, 7, 15), type: 2, name: "Положение ризы Богородицы в Лахерне"),
  Event(date:DateTime(2018, 7, 23), type: 2, name: "Положение ризы Господа Бога и Спаса нашего Исуса Христа во граде Москве"),
  Event(date:DateTime(2018, 8, 10), type: 2, name: "Празднование явлению иконы Богородицы Смоленския, именуемой Одигитрия"),
  Event(date:DateTime(2018, 8, 14), type: 2, name: "Происхождение Креста Господня. Всемилостивого Спаса"),
  Event(date:DateTime(2018, 11, 4), type: 2, name: "Празднование явлению иконы Пресвятыя Богородицы во граде Казани"),
  Event(date:DateTime(2018, 11, 8), type: 2, name: "Св.влмч. Димитрия Солунскаго"),
  Event(date:DateTime(2018, 11, 11), type: 2, name: "Свт. Амвросия, митрополита Белокриницкаго"),
  Event(date:DateTime(2018, 11, 21), type: 2, name: "Собор св. архистратига Михаила и прочих сил безплотных"),
  Event(date:DateTime(2018, 12, 10), type: 2, name: "Знамение от иконы Пресвятыя Богородицы в Великом Новеграде"),
  Event(date:DateTime(2018, 12, 19), type: 2, name: "Иже во святых отца нашего Николы, архиеп. Мир Ликийских, чудотворца"),
];