import 'package:flutter/material.dart';
import 'package:flutter_custom_progress_bar/flutter_custom_progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Custom Scroll Bar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  const [
          ProgressBar(
            totalRatio: 50,
            backgroundColor: Colors.grey,
            progressColor: Colors.green,
          ),
          SizedBox(
            height: 50,
          ),
          CircularProgressBar(
            ratio: 50,
            size: 200,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          ),

        ],
      ),
       );
  }
}
