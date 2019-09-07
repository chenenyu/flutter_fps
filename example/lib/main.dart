import 'package:flutter/material.dart';
import 'package:flutter_fps/flutter_fps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fps Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Fps.instance.start(context);
    Fps.instance.addFpsCallback((l) {
      l.forEach((f) {
        print(f.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: EdgeInsets.all(8),
        children: List.generate(100, (index) {
          return Stack(
            children: <Widget>[
              Image.network(
                'https://source.unsplash.com/random/200x200?index=$index',
                fit: BoxFit.cover,
              ),
              Text('$index'),
            ],
          );
        }),
      ),
    );
  }
}
