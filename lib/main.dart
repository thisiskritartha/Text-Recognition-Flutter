import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? img;
  late ImagePicker imagePicker;
  dynamic textRecognizer;
  String result = '';

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  void dispose() {
    super.dispose();
  }

  imgFromGallery() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    if (img != null) {
      setState(() {
        img;
      });
      doTextRecognition();
    }
  }

  imgFromCamera() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    img = File(image!.path);
    if (img != null) {
      setState(() {
        img;
      });
      doTextRecognition();
    }
  }

  doTextRecognition() async {
    InputImage inputImage = InputImage.fromFile(img!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    result = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoint = block.cornerPoints;
      final List<String> recognizedLanugage = block.recognizedLanguages;
      //result += '${recognizedLanugage}';
      for (TextLine line in block.lines) {
        //TextBlock
        for (TextElement element in line.elements) {
          //TextElement
        }
      }
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/bg2.jpg'),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/notebook.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 280,
                width: 250,
                margin: const EdgeInsets.only(top: 80),
                padding: const EdgeInsets.only(left: 28, right: 18, bottom: 5),
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 140),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'images/clipboard.png',
                        height: 250,
                        width: 250,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: imgFromGallery,
                      onLongPress: imgFromCamera,
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: img != null
                            ? Container(
                                margin: const EdgeInsets.only(left: 35),
                                child: Image.file(
                                  img!,
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.fill,
                                ))
                            : const SizedBox(
                                height: 180,
                                width: 220,
                                child: Icon(
                                  Icons.find_in_page,
                                  color: Colors.pink,
                                  size: 50,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
