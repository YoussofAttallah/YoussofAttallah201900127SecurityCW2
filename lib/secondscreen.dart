import 'package:cw_1/functions.dart';
import 'package:cw_1/memo_screen.dart';
import 'package:flutter/material.dart';
import 'package:cw_1/mongodb.dart';

var q1 = "Be vulnerable, be courageous, and find comfort in the uncomfortable.";
var q2 =
    "Prepare like you have never won and perform like you have never lost.";
var q3 = "Trust the process.";
var q4 = "A vision is a dream with a plan.";
var q5 = "You only fail when you stop trying.";
var list = [q1, q2, q3, q4, q5];

class SecondScreen extends StatefulWidget {
  final MongoDb mongoDataBase;
  final List elements;
  const SecondScreen(this.elements, this.mongoDataBase, {super.key});
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    var entries = widget.elements;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MemoScreen(widget.mongoDataBase)));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          var entry = entries[index];
          return ListTile(
            title: Text(decryptWithAES(entry["title"])),
            subtitle: Text(decryptWithAES(entry["body"])),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
