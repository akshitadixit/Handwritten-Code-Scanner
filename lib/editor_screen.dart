// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, prefer_final_fields

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:imgscanner/code_editor.dart';

String defaultLangValue = 'python';
String finalUrl = '';
String filePath = '';
File file = (file);
var code;
var input;
var output;
var stderr;
var toShow;
var error;
const String runBaseUrl = "https://code-compiler.p.rapidapi.com/v2";
int pos = 0;

class Editor extends StatefulWidget {
  final String initialText;
  const Editor(this.initialText, {Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  var _controller = TextEditingController();
  var inputtextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
  }

  String getLanguage(selectLang) {
    if (selectLang == 'c') {
      return "6";
    } else if (selectLang == 'kotlin') {
      return "43";
    } else if (selectLang == 'typescript') {
      return "60";
    } else if (selectLang == 'java') {
      return "4";
    } else if (selectLang == 'bash') {
      return "38";
    } else if (selectLang == 'clojure') {
      return "47";
    } else if (selectLang == 'cobol') {
      return "49";
    } else if (selectLang == 'csharp') {
      return "1";
    } else if (selectLang == 'javascript') {
      return "17";
    } else if (selectLang == 'elixir') {
      return "41";
    } else if (selectLang == 'python') {
      return "5";
    } else if (selectLang == 'cpp') {
      return "7";
    } else {
      return selectLang.toString();
    }
  }

  Future getResponse(selectLang) async {
    var body = json.encode({
      "LanguageChoice": getLanguage(selectLang),
      "Program": code,
    });
    Map<String, String> header = {
      'content-type': 'application/json',
      'X-RapidAPI-Host': 'code-compiler.p.rapidapi.com',
      'X-RapidAPI-Key': '8c0ed262e2mshfd1746f6f6e767dp19a531jsnfeef72c8d4b6'
    };
    final response = await http.post(
        Uri.parse("https://code-compiler.p.rapidapi.com/v2"),
        body: body,
        headers: header);
    final responseJson = json.decode(response.body);
    getOutput(responseJson);
  }

  Future getInput(selectLang) async {
    var body = json.encode({
      "LanguageChoice": getLanguage(selectLang),
      "Program": code,
      "Input": input,
    });
    print(body);
    Map<String, String> header = {
      'content-type': 'application/json',
      'X-RapidAPI-Host': 'code-compiler.p.rapidapi.com',
      'X-RapidAPI-Key': '8c0ed262e2mshfd1746f6f6e767dp19a531jsnfeef72c8d4b6'
    };
    final response = await http.post(
      Uri.parse("https://code-compiler.p.rapidapi.com/v2"),
      body: body,
      headers: header,
    );
    final responseJson = json.decode(response.body);
    getOutput(responseJson);
  }

  void getOutput(responseJson) {
    output = responseJson['Result'];
    error = responseJson['Errors'];
    if (output != '') {
      print(output);
      toShow = output;
    } else if (error != '') {
      print(error);
      toShow = error;
    }
    openOutputArea(context);
  }

  openInputArea(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  controller: inputtextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.blueGrey[900],
                      contentPadding: const EdgeInsets.all(8.0),
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: "Enter your input here (if any)"),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  input = inputtextController.text;
                  if (input != '') {
                    getInput(defaultLangValue);
                  } else {
                    getResponse(defaultLangValue);
                  }
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                ),
                child: const Text(
                  "Execute",
                ),
              ),
            ],
          );
        });
  }

  openOutputArea(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 38, 16, 38),
            child: Text(toShow),
          );
        });
  }

  final List<String> languages = [
    'python',
    'cpp',
    'c',
    'kotlin',
    'java',
    'typescript',
    'bash',
    'clojure',
    'cobol',
    'csharp',
    'javascript',
    'elixir',
  ];

  void getFile() async {
    filePath = (await FilePicker.platform.getDirectoryPath())!;
    Future<String> getFileData(String path) async {
      return await rootBundle.loadString(path);
    }

    String data = await getFileData(filePath);
    setState(() {
      _controller.text = data;
    });
    debugPrint(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          "Editor",
          style: TextStyle(color: Colors.pink),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: DropdownButton<String>(
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              dropdownColor: Colors.blueGrey[900],
              value: defaultLangValue,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              onChanged: (newValue) {
                setState(() {
                  defaultLangValue = newValue!;
                });
              },
              items: languages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toUpperCase(),
                    style: TextStyle(color: Colors.pink[500]),
                  ),
                );
              }).toList(),
            ),
          ),
          Ink(
            decoration: ShapeDecoration(
              color: Colors.blueGrey[900],
              shape: const CircleBorder(),
            ),
            child: IconButton(
              iconSize: 30.0,
              icon: const Icon(
                Icons.add,
                color: Colors.grey,
                size: 23,
              ),
              onPressed: () {
                getFile();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: customTextField(controller: _controller),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.pink),
            onPressed: () {
              code = _controller.text;
              debugPrint(code);
              openInputArea(context);
            },
            child: const Text(
              "Execute",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.0),
            ),
          ),
        ],
      ),
    );
  }
}
