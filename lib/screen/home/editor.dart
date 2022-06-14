import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as f_quill;
import 'package:submission_bmafup/screen/base/base_material_app.dart';

import '../../data/note_repository.dart';

class Editor extends StatefulWidget {
  final String? data;

  const Editor({Key? key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  f_quill.QuillController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = f_quill.QuillController(
      document: f_quill.Document.fromJson(jsonDecode(widget.data ?? "")),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller != null) {
      return BaseMaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel),
                      ),
                      const Text(
                        "EDIT NOTE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          String data =
                              jsonEncode(_controller?.document.toDelta());
                          NoteRepository.getInstance()
                              .save("test_test", data)
                              .then((value) => print(value));
                        },
                        icon: const Icon(Icons.save),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 16.0, right: 16.0),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: f_quill.QuillEditor.basic(
                      controller: controller,
                      readOnly: false,
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                f_quill.QuillToolbar.basic(controller: controller),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
