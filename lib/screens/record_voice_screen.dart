import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class RecordVoiceScreen extends StatefulWidget {
  const RecordVoiceScreen({super.key});

  @override
  RecordVoiceScreenState createState() => RecordVoiceScreenState();
}

class RecordVoiceScreenState extends State<RecordVoiceScreen> {
  List<Map<String, String>> allTexts = [];
  List<Map<String, String>> displayedTexts = [];
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    loadTexts();
  }

  Future<void> loadTexts() async {
    try {
      String data = await rootBundle.loadString('/utils/text1.json');
      List<dynamic> jsonList = json.decode(data);

      List<Map<String, String>> parsedTexts = jsonList
          .where((item) =>
              int.tryParse(item["ID"] ?? '0') != null &&
              int.parse(item["ID"]) <= 100)
          .map<Map<String, String>>((item) => {
                "ID": item["ID"].toString(),
                "text": item["text"].toString(),
              })
          .toList();

      setState(() {
        allTexts = parsedTexts;
        updateDisplayedTexts();
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  void updateDisplayedTexts() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    setState(() {
      displayedTexts = allTexts.sublist(
          startIndex, endIndex > allTexts.length ? allTexts.length : endIndex);
    });
  }

  void nextPage() {
    if (currentPage * itemsPerPage < allTexts.length) {
      setState(() {
        currentPage++;
        updateDisplayedTexts();
      });
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        updateDisplayedTexts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: displayedTexts
                .map((item) => Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: Text(
                        '${item["ID"]}. ${item["text"]}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentPage > 1 ? previousPage : null,
                child: const Text("이전"),
              ),
              Text(
                "$currentPage / ${allTexts.length ~/ itemsPerPage}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: currentPage * itemsPerPage < allTexts.length
                    ? nextPage
                    : null,
                child: const Text("다음"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
