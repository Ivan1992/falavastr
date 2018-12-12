// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:falavastr/cstext.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'backdrop.dart';

/// tracks what can be displayed in the front panel
enum FrontPanels { tealPanel, limePanel }

/// Tracks which front panel should be displayed
class FrontPanelModel extends Model {
  FrontPanelModel(this._activePanel);
  FrontPanels _activePanel;

  FrontPanels get activePanelType => _activePanel;

  Widget panelTitle(BuildContext context) {
    return Container(
      color: _activePanel == FrontPanels.tealPanel
          ? Color(0xFF7EBDC2)
          : Colors.lime,
      padding: EdgeInsetsDirectional.only(start: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: _activePanel == FrontPanels.tealPanel
            ? Text('Святцы')
            : Text('Lime Panel'),
      ),
    );
  }

  Widget get activePanel =>
      _activePanel == FrontPanels.tealPanel ? TealPanel() : LimePanel();

  void activate(FrontPanels panel) {
    _activePanel = panel;
    notifyListeners();
  }
}

class ComplexExample extends StatelessWidget {
  final AppBar appBar = AppBar(
    title: Text('Алавастр'),
  );
  @override
  Widget build(BuildContext context) => ScopedModel(
      model: FrontPanelModel(FrontPanels.tealPanel),
      child: Scaffold(body: SafeArea(child: Panels(appBar))));
}

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);
  final AppBar appBar;

  Panels(this.appBar);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FrontPanelModel>(
      builder: (context, _, model) => Backdrop(
            frontLayer: model.activePanel,
            backLayer: BackPanel(
              frontPanelOpen: frontPanelVisible,
              appBar: appBar,
            ),
            frontHeader: model.panelTitle(context),
            panelVisible: frontPanelVisible,
            frontPanelOpenHeight: 0.0, //appBar.preferredSize.height, //40.0,
            frontHeaderHeight: 48.0,
          ),
    );
  }
}

class TealPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: CsText(),
      );
}

class LimePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.lime, child: Center(child: Text('Lime panel5')));
}

/// This needs to be a stateful widget in order to display which front panel is open
class BackPanel extends StatefulWidget {
  BackPanel({@required this.frontPanelOpen, this.appBar});
  final ValueNotifier<bool> frontPanelOpen;
  final AppBar appBar;

  @override
  createState() => _BackPanelState(appBar);
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;
  AppBar appBar;

  _BackPanelState(this.appBar);

  @override
  initState() {
    super.initState();
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  void _subscribeToValueNotifier() => setState(() {
        panelOpen = widget.frontPanelOpen.value;
        if (panelOpen) {
          appBar = null;
        } else {
          appBar = AppBar(
            title: Text("Алавастр"),
          );
        }
      });

  /// Required for resubscribing when hot reload occurs
  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  Widget createMenu(BuildContext context) {
    List<String> names = [
      "СВЯТЦЫ",
      "ТРОПАРИ",
      "ЕВАНГЕЛИЕ",
      "АПОСТОЛ",
      "ОКТАЙ",
      "ТРИОДЬ"
    ];
    TextTheme theme = Theme.of(context).textTheme;
    return Container(
      /* padding: EdgeInsets.all(20.0), */
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("12 дек",
                        style: TextStyle(
                            fontSize: theme.title.fontSize,
                            color: theme.title.color)),
                    Text("среда",
                        style: TextStyle(
                            fontSize: theme.caption.fontSize,
                            color: theme.caption.color,
                            fontFamily: "OpenSans"))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text("Пища постная без масла",
                        style: TextStyle(fontFamily: "OpenSans")),
                    RaisedButton(
                      child: Text("Подробнее...",
                          style: TextStyle(fontFamily: "OpenSans")),
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
            Text(
              "29-я седмица по Пятидесятнице",
              style: TextStyle(fontFamily: "OpenSans"),
            ),
            Expanded(
              child: ListView(
                children: names
                    .map<Widget>((name) => Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Material(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            color: Color.lerp(Theme.of(context).backgroundColor,
                                Colors.white, 0.3),
                            child: ScopedModelDescendant<FrontPanelModel>(
                              rebuildOnChange: false,
                              builder: (context, _, model) => ListTile(
                                    title: Center(
                                      child: Row(children: <Widget>[
                                        Icon(Icons.book),
                                        Text(name,
                                          style: TextStyle(
                                            fontFamily: "Balkara",
                                          )),
                                      ],)
                                    ),
                                    selected: false,
                                    onTap: () {
                                      model.activate(FrontPanels.tealPanel);
                                      widget.frontPanelOpen.value = true;
                                    },
                                  ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: createMenu(context),
    );
  }

  Widget buildDefault() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text('Front panel is ${panelOpen ? "open" : "closed"}'),
          )),
          Center(
              child: ScopedModelDescendant<FrontPanelModel>(
            rebuildOnChange: false,
            builder: (context, _, model) => RaisedButton(
                  color: Colors.teal,
                  child: Text('show teal panel'),
                  onPressed: () {
                    model.activate(FrontPanels.tealPanel);
                    widget.frontPanelOpen.value = true;
                  },
                ),
          )),
          Center(
              child: ScopedModelDescendant<FrontPanelModel>(
            rebuildOnChange: false,
            builder: (context, _, model) => RaisedButton(
                  color: Colors.lime,
                  child: Text('show lime panel'),
                  onPressed: () {
                    model.activate(FrontPanels.limePanel);
                    widget.frontPanelOpen.value = true;
                  },
                ),
          )),
          Center(
              child: RaisedButton(
            child: Text('show current panel'),
            onPressed: () {
              widget.frontPanelOpen.value = true;
            },
          )),
          // will not be seen; covered by front panel
          Center(child: Text('Bottom of Panel')),
        ]);
  }
}
