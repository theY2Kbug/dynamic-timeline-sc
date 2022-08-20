import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:intl/intl.dart';
import 'package:web_form/card_model.dart';
import 'package:web_form/custom_drawer.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'timeline_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Timeline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dynamic Timeline'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Offset offset = const Offset(0, 0);
  bool addIsPressed = false;
  bool isFormOpen = false;
  bool isClicked = false;
  double index = 0;
  double maxIndex = 0;
  double turns = 0.0;
  final listKey = GlobalKey<AnimatedListState>();
  List<EntryItem> items = []; //List used to store the entered details
  late AnimationController controller;
  final titleTextController = TextEditingController();
  final descTextController = TextEditingController();

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    titleTextController.dispose();
    descTextController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset addDistance =
        addIsPressed ? const Offset(5, 5) : const Offset(10, 10);
    double addBlur = addIsPressed ? 12.0 : 20.0;
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.275;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white10,
          body: Stack(
            children: [
              AnimatedList(
                key: listKey,
                physics: const ClampingScrollPhysics(),
                // shrinkWrap: true,
                initialItemCount: items.length,
                itemBuilder: (context, index, animation) {
                  return Center(
                    child: Padding(
                      padding: (index == 0)
                          ? const EdgeInsets.only(top: 48.0, bottom: 0.0)
                          : (index == items.length - 1)
                              ? const EdgeInsets.only(top: 0.0, bottom: 48.0)
                              : const EdgeInsets.symmetric(vertical: 0.0),
                      child: TimelineCard(
                        idx: index,
                        len: items.length,
                        item: items[index],
                        animation: animation,
                        onClicked: () => removeItem(index),
                      ),
                    ),
                  );
                },
              ),
              if (items.isEmpty)
                const Center(
                  child: Text(
                    "Add item using sidebar; Click on added item to edit/remove",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                right: isFormOpen ? 0 : -sidebarSize * 0.78,
                top: 0,
                curve: Curves.easeInOutCubicEmphasized,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: sidebarSize,
                    child: MouseRegion(
                      onHover: (PointerEvent details) {
                        setState(() {
                          offset = details.position;
                        });
                      },
                      onExit: (details) {
                        setState(() {
                          offset = const Offset(0, 0);
                        });
                      },
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(sidebarSize, mediaQuery.height),
                            painter: DrawerPainter(
                              offset: offset,
                              screenWidth: mediaQuery.width,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height,
                            width: sidebarSize,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  alignment: Alignment.centerLeft,
                                  height: mediaQuery.height * 0.1,
                                  child: AnimatedRotation(
                                    turns: turns,
                                    duration: const Duration(milliseconds: 750),
                                    curve: Curves.easeInOutExpo,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isClicked) {
                                          setState(() {
                                            turns -= 1 / 4;
                                            isFormOpen = false;
                                          });
                                          controller.reverse();
                                        } else {
                                          setState(() {
                                            turns += 1 / 4;
                                            isFormOpen = true;
                                          });
                                          controller.forward();
                                        }
                                        isClicked = !isClicked;
                                      },
                                      child: AnimatedContainer(
                                        curve: Curves.easeOutExpo,
                                        duration: const Duration(seconds: 1),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color: const Color.fromARGB(
                                              255, 237, 237, 237),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 30.0,
                                              offset: isClicked
                                                  ? const Offset(20, -20)
                                                  : const Offset(20, 20),
                                              color: Colors.grey,
                                            ),
                                            BoxShadow(
                                              blurRadius: 30.0,
                                              offset: isClicked
                                                  ? const Offset(-20, 20)
                                                  : const Offset(-20, -20),
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        child: SizedBox(
                                          height: 75,
                                          width: 75,
                                          child: Center(
                                            child: AnimatedIcon(
                                              icon: AnimatedIcons.menu_close,
                                              progress: controller,
                                              size: 50,
                                              color: const Color.fromARGB(
                                                  255, 53, 53, 53),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.5,
                                ),
                                SizedBox(
                                  height: mediaQuery.height * 0.7,
                                  width: sidebarSize,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 32.0,
                                      left: 120.0,
                                      right: 16.0,
                                      bottom: 32.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Title:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        TextField(
                                          style: const TextStyle(fontSize: 20),
                                          controller: titleTextController,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: "Enter title",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                titleTextController.clear();
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                        const Text("Description:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            )),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        TextFormField(
                                          minLines: 4,
                                          maxLines: 6,
                                          controller: descTextController,
                                          style: const TextStyle(fontSize: 20),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: "Enter description",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                descTextController.clear();
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                        Text(
                                          "Insert At Index: ${index.toStringAsFixed(0)} ${(index == maxIndex) ? "(end)" : (index == 0) ? "(beginning)" : ""}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Slider(
                                          value: index,
                                          min: 0,
                                          max: maxIndex,
                                          divisions: maxIndex.toInt() == 0
                                              ? 1
                                              : maxIndex.toInt(),
                                          onChanged: (value) {
                                            setState(() {
                                              index = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 48),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Listener(
                                              onPointerUp: (_) {
                                                setState(() {
                                                  addIsPressed = false;
                                                });
                                              },
                                              onPointerDown: (_) {
                                                setState(
                                                  () {
                                                    addIsPressed = true;
                                                    maxIndex++;
                                                    EntryItem temp = EntryItem(
                                                      title: (titleTextController
                                                              .text.isEmpty)
                                                          ? "Click me to edit title"
                                                          : titleTextController
                                                              .text,
                                                      desc: (descTextController
                                                              .text.isEmpty)
                                                          ? "Oops! No form validation; Edit description instead"
                                                          : descTextController
                                                              .text,
                                                      time: DateFormat.yMMMd().add_jm().format(DateTime.now())
                                                    );
                                                    insertItem(
                                                        index.toInt(), temp);
                                                  },
                                                );
                                              },
                                              child: AnimatedContainer(
                                                padding:
                                                    const EdgeInsets.all(25),
                                                duration: const Duration(
                                                    milliseconds: 75),
                                                curve: Curves.bounceInOut,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 237, 237, 237),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade600,
                                                      offset: addDistance,
                                                      blurRadius: addBlur,
                                                      spreadRadius: 1,
                                                      inset: addIsPressed,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      offset: -addDistance,
                                                      blurRadius: addBlur,
                                                      spreadRadius: 1,
                                                      inset: addIsPressed,
                                                    ),
                                                  ],
                                                ),
                                                child: const Text(
                                                  "Add",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void insertItem(int index, EntryItem newItem) {
    items.insert(index, newItem);
    listKey.currentState!.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  void removeItem(int idx) {
    setState(() {
      index = (index != 0) ? index - 1 : 0;
      maxIndex--;
    });
    final removedItem = items[idx];
    items.removeAt(idx);
    listKey.currentState!.removeItem(
      idx,
      (context, animation) => TimelineCard(
        idx: idx,
        len: items.length,
        item: removedItem,
        animation: animation,
        onClicked: () {},
      ),
    );
  }
}
