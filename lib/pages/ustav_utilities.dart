import 'dart:async';

import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

class PopupListBuilder extends StatelessWidget {
  final Function updateCsText;
  final BuildContext context;

  PopupListBuilder({Key key, this.updateCsText, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.format_size),
      padding: EdgeInsets.zero,
      onSelected: (val) {},
      itemBuilder: _buildMenu,
    );
  }

  List<PopupMenuEntry<String>> _buildMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      _createNightMode("Ночная тема", true),
      _createNightMode("Дневная тема", false),
      const PopupMenuDivider(),
      _createFontTile('Orthodox', 'Ортодокс'),
      _createFontTile('Turaevo', 'Тураево'),
      _createFontTile('Grebnev', 'Гребнев'),
      const PopupMenuDivider(),
      _createTextLabel("Размер текста"),
      _createSlider(FontSliderWrapper()),
      _createTextLabel("Размер закладок"),
      _createSlider(FavSliderWrapper()),
    ];
  }

  void _changeFont(String value) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    appBloc.inFontFamily.add(value);
  }

  void _changeNightMode(bool value) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    appBloc.inNightMode.add(value);
  }

  PopupMenuItem<String> _createFontTile(String name, String label) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return PopupMenuItem<String>(
      value: name,
      child: StreamBuilder(
          stream: appBloc.outFontFamily,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            bool selected = snapshot.hasData ? (snapshot.data == name) : false;
            return ListTile(
              onTap: () => _changeFont(name),
              leading: Icon(Icons.text_format),
              title: Text(label, style: TextStyle(fontFamily: name)),
              trailing: selected ? Icon(Icons.check) : null,
            );
          }),
    );
  }

  PopupMenuItem<String> _createNightMode(String text, bool value) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return PopupMenuItem<String>(
      value: text,
      child: ListTile(
        leading: Icon(Icons.format_color_fill),
        title: Text(text),
        onTap: () {
          _changeNightMode(value);
          updateCsText(value);
        },
        trailing: StreamBuilder(
          stream: appBloc.outNightMode,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return (snapshot.hasData && (snapshot.data == value))
                ? Icon(Icons.check)
                : Container(width: 0.0, height: 0.0);
          },
        ),
      ),
    );
  }

  PopupMenuItem<String> _createTextLabel(String text) {
    return PopupMenuItem<String>(
      value: "",
      child: Text(text),
    );
  }

  PopupMenuItem<String> _createSlider(Widget w) {
    return PopupMenuItem<String>(
      value: "",
      child: w,
    );
  }
}

class FontSliderWrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FontSliderWrapperState();
}

class _FontSliderWrapperState extends State<FontSliderWrapper> {
  double _fontSize = 2.0;

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    return StreamBuilder(
      stream: appBloc.outFontSize,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        _fontSize = snapshot.data;
        return Slider(
          onChanged: (val) {
            final ApplicationBloc appBloc =
                BlocProvider.of<ApplicationBloc>(context);
            _fontSize = val;
            setState(() {});
            appBloc.inFontSize.add(_fontSize);
          },
          value: _fontSize,
          min: 1.0,
          max: 4.0,
          divisions: 6,
          label: "$_fontSize",
        );
      },
    );
  }
}

class FavSliderWrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavSliderWrapperState();
}

class _FavSliderWrapperState extends State<FavSliderWrapper> {
  double _favSize = 0.5;

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    return StreamBuilder(
      stream: appBloc.outFavSize,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        _favSize = snapshot.data;
        return Slider(
          onChanged: (val) {
            final ApplicationBloc appBloc =
                BlocProvider.of<ApplicationBloc>(context);
            _favSize = val / 100;
            setState(() {});
            appBloc.inFavSize.add(_favSize);
          },
          value: _favSize * 100,
          min: 10.0,
          max: 100.0,
          divisions: 9,
          label: "${(_favSize * 100).round()}%",
        );
      },
    );
  }
}
