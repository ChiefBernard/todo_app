import 'package:flutter/material.dart';
import 'dart:async';
import 'package:todo_v2/utils.dart';
import 'todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _todoList = [];
  late Future<List<Todo>> futureTodos;
  Future<String>? futureTodo;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    futureTodos = fetchTodos();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToList(value) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      futureTodo = createTodo(value);
      ///!!! Do invalidate data !!!
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        title: TextField(
          decoration: const InputDecoration(
            //prefixIcon: Icon(Icons.search),
            //suffixIcon: Icon(Icons.clear),
            //labelText: 'Outlined',
            hintText: 'Что сделать сегодня?',
            //helperText: 'supporting text',
            border: OutlineInputBorder(),
          ),
          controller: _controller,
          onSubmitted: (value) {
            _controller.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Вы набрали: $value')));
            _addToList(value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Удалить выполненные',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вы нажали кнопку Удалить')));
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<List<Todo>>(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: const EdgeInsets.all(8),
                children: snapshot.data!.map((element) =>
                  ListTile(
                    leading: Checkbox(value: element.completed, onChanged: (newValue) {}),
                    title: Text(
                      element.task, style: element.completed ? TextStyle(decoration: TextDecoration.lineThrough) : null
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: 'Удалить',
                      onPressed: () {},
                    ),
                  )
                  /* Container(
                    height: 50,
                    color: Colors.amber,
                    child: Center(child: Text('Entry ${element.task}')),
                  ), */
                ).toList()
              );
              //return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
