import 'dart:math';

import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';

///
void main() {
  ///
  runApp(const MyApp());
}

///
class MyApp extends StatefulWidget {
  ///
  const MyApp({Key? key}) : super(key: key);

  ///
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///
  final ScrollController scrollController = ScrollController();

  ///
  int count = 7;

  ///
  final itemController = DashboardItemController<String>(items: [
    DashboardItem(
      identifier: "a",
      startX: 0,
      startY: 0,
      width: 2,
      height: 2,
    ),
    DashboardItem(
        identifier: "b",
        startX: 0,
        startY: 2,
        width: 4,
        height: 2,
        minWidth: 1),
    DashboardItem(
        identifier: "c",
        startX: 1,
        startY: 4,
        width: 3,
        height: 1,
        minWidth: 1,
        maxWidth: 3),
    DashboardItem(identifier: "d", startX: 2, startY: 0, width: 1, height: 1),
    DashboardItem(identifier: "e", startX: 2, startY: 5, width: 2, height: 6),
    DashboardItem(identifier: "f", startX: 0, startY: 5, width: 2, height: 1),
    DashboardItem(identifier: "g", startX: 1, startY: 6, width: 1, height: 3),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  itemController.setEditMode(!itemController.isEditing);
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            count++;
            itemController.add(DashboardItem(
                identifier: "$count", width: 3, height: 3, minWidth: 2));
          },
        ),
        body: DashboardWidget(itemController: itemController),
      ),
    );
  }
}

///
class DashboardWidget extends StatefulWidget {
  ///
  const DashboardWidget({Key? key, required this.itemController})
      : super(key: key);

  ///
  final DashboardItemController<String> itemController;

  ///
  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  ///
  Color getRandomColor() {
    var r = Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 1);
  }

  ///
  final Map<String, Color> _colors = const {
    "a": Colors.red,
    "b": Colors.yellow,
    "c": Colors.indigo,
    "d": Colors.green,
    "e": Colors.purple,
    "f": Colors.blue,
    "g": Colors.teal,
    "h": Colors.yellowAccent
  };

  ///
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dashboard(
        shrinkToPlace: false,
        slideToTop: false,
        padding: const EdgeInsets.all(16),
        mainAxisSpace: 8,
        crossAxisSpace: 8,
        dashboardItemController: widget.itemController,
        slotCount: 4,
        editModeSettings: const EditModeSettings(
            resizeCursorSide: 30,
            foregroundStyle: EditModeForegroundStyle(
                fillColor: Colors.black12,
                sideWidth: 10,
                innerRadius: 8,
                outherRadius: 8,
                shadowColor: Colors.transparent,
                shadowTransparentOccluder: true),
            backgroundStyle: EditModeBackgroundStyle(
                lineColor: Colors.black38,
                lineWidth: 1,
                doubleLineHorizontal: true,
                doubleLineVertical: true)),
        itemBuilder: (DashboardItem item, ItemCurrentLayout layout) {
          return InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: _colors[item.identifier] ?? getRandomColor(),
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(
                      "ID: ${item.identifier} , Layout: ${layout.origin}")),
            ),
          );
        },
      ),
    );
  }
}