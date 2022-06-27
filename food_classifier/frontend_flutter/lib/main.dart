import 'dart:convert';
import 'dart:io';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? imagePath;
  late String choice;
  bool uploadedImage = false;
  late String prediction;
  late Map<String, double> results;

  Future<void> loadAndDisplayImage(String choice) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    if (choice == 'gallery') {
      image = await picker.pickImage(source: ImageSource.gallery);
    }
    if (choice == 'camera') {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    imagePath = image?.path as String;
    File file = File(imagePath as String);
    await uploadImage(file);
    uploadedImage = true;
    setState(() {});
  }

  uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://099c-2405-201-c02c-a0ac-4dcf-5774-3a6b-8a8b.in.ngrok.io/"),
    );
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    // print("request: " + request.toString());
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    var prediction = jsonDecode(res.body);
    // print(prediction.runtimeType); // _InternalLinkedHashMap<String, dynamic>
    // print(prediction); // {Chole bhature: 0.060959529131650925, Jalebi: 0.08678154647350311, Johnnycake: 0.05310630425810814, Puri: 0.24177610874176025}
    results = Map<String, double>.from(prediction);
    final reverseM = LinkedHashMap.fromEntries(results.entries.toList().reversed);
    results = reverseM;
  }

  @override
  void initState() {
    super.initState();
    // print("Init state function got invoked");
    // We are loading the model during the server initialization
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Application name
        title: 'Flutter Stateful Clicker Counter',
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Food Classification App"),
          ),
          body: Center(
            child: uploadedImage
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.file(
                            File(imagePath as String),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: results.entries.map(
                              (entry) {
                                var w = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(entry.key),
                                    ),
                                    LinearPercentIndicator(
                                      width: 250.0,
                                      animation: true,
                                      animationDuration: 1000,
                                      lineHeight: 14.0,
                                      percent: (entry.value),
                                      center: Text("${entry.value}"),
                                      barRadius: const Radius.circular(10.0),
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.blue,
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    )
                                  ],
                                );
                                return w;
                              },
                            ).toList(),
                          ),
                        )
                      ],
                    ),
                  )
                : const Text(
                    "Upload an image....",
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                  child: const Icon(Icons.image),
                  onPressed: () async {
                    await loadAndDisplayImage('gallery');
                  }),
              const SizedBox(width: 50),
              FloatingActionButton(
                  child: const Icon(Icons.camera),
                  onPressed: () async {
                    await loadAndDisplayImage('camera');
                  }),
            ],
          ),
        ));
  }
}
