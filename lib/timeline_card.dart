import 'package:flutter/material.dart';
import 'package:web_form/card_model.dart';

import 'arrow_painter.dart';

class TimelineCard extends StatefulWidget {
  final int idx;
  final int len;
  final EntryItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;
  const TimelineCard({
    required this.item,
    required this.animation,
    required this.onClicked,
    required this.idx,
    required this.len,
    Key? key,
  }) : super(key: key);

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  bool showButton = false;
  late TextEditingController titleEditController;
  late TextEditingController descEditController;

  @override
  void initState() {
    super.initState();
    titleEditController = TextEditingController(text: widget.item.title);
    descEditController = TextEditingController(text: widget.item.desc);
  }

  @override
  void dispose() {
    titleEditController.dispose();
    descEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: widget.animation, curve: Curves.fastOutSlowIn),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "${widget.item.title}",
                      ),
                      subtitle: Text(
                        "Created at: ${widget.item.time}",
                      ),
                      onTap: () {
                        setState(
                          () {
                            showButton = !showButton;
                          },
                        );
                      },
                    ),
                    if (showButton)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                editDialog();
                              },
                              child: const Icon(
                                Icons.edit_note_rounded,
                                size: 16,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: widget.onClicked,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_forever,
                                size: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        top: 8.0,
                      ),
                      child: Text(
                        "${widget.item.desc}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.idx != widget.len - 1)
            Container(
              width: 400,
              height: 150,
              color: Colors.transparent.withOpacity(0),
              child: CustomPaint(
                foregroundPainter: ArrowPainter(),
              ),
            ),
        ],
      ),
    );
  }

  Future editDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Edit Details"),
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  controller: titleEditController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter title",
                    suffixIcon: IconButton(
                      onPressed: () {
                        titleEditController.clear();
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
                  controller: descEditController,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter description",
                    suffixIcon: IconButton(
                      onPressed: () {
                        descEditController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                titleEditController.text = widget.item.title!;
                descEditController.text = widget.item.desc!;
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
              ),
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.item.title = titleEditController.text;
                  widget.item.desc = descEditController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
}
