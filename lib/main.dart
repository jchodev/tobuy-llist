import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:need_resume/need_resume.dart';
import 'package:to_buy_list/firebase_options.dart';

import 'di/app_module.dart';
import 'features/task/di/task_module.dart';
import 'features/task/ui.dart';
//import 'features/task/ui/category_list_screen.dart';
import 'features/firebase_task/view/screen/category_list_screen.dart';
import 'mvvm/observer.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupAppModule();
  setupTaskLocator();
  runApp(
      //MyApp()
    MyApp2()
      // MyCheckboxExample(
      //   title: 'tit1',
      //   subtitle: 'ede',
      //   checked: true,
      //   onClicked:(bool value) {
      //     print("Button clicked with value: $value");
      //   }
      // )
  );

}

typedef OnCheckboxClicked = void Function(bool value);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home:  TaskWidget(),
    );
  }
}

class MyCheckboxExample extends StatefulWidget {
  final bool checked;
  final String title;
  final String subtitle;
  final OnCheckboxClicked onClicked;

  const MyCheckboxExample(
      { Key? key, required this.title, required this.subtitle, required this.checked, required this.onClicked }
      ) : super(key: key);

  @override
  _MyCheckboxExampleState createState() => _MyCheckboxExampleState();
}

class _MyCheckboxExampleState extends State<MyCheckboxExample> {

  late bool _isChecked;
  late String _title;
  late String _subtitle;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked;
    _title = widget.title;
    _subtitle = widget.subtitle;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Card Example'),
        ),
        body: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                  children: [
                    const Text(
                      'Add',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const Text(
                      'Add2',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      backgroundColor: Colors.grey, // Set a background color
                      radius: 16.0, // Adjust the circle size
                      child: Text(
                        '12', // Number to display
                        style: TextStyle(
                          color: Colors.white, // Set text color
                          fontSize: 10.0, // Adjust text size
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Checkbox(value: _isChecked, onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue!;
                      });
                      widget.onClicked(newValue!);
                    })
                  ]
              ),
              // child: Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: <Widget>[
              //
              //     ListTile(
              //       leading: Icon(Icons.album),
              //       title: Text(title),
              //       subtitle: Text(subtitle),
              //     ),
              //     ButtonBar(
              //       children: <Widget>[
              //         IconButton(
              //           icon: const Icon(Icons.close),
              //           onPressed: () {},
              //         ),
              //         IconButton(
              //           icon: const Icon(Icons.add),
              //           onPressed: () {},
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

//test
class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Application',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
          useMaterial3: true,
        ),
        home: FirestoreCategoryListScreen()
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ResumableState<HomeScreen> implements EventObserver{
  
  @override
  void onReady() {
    // Implement your code inside here

    print('HomeScreen is ready!');
  }

  @override
  void onResume() {
    // Implement your code inside here

    print('HomeScreen is resumed!');
  }

  @override
  void onPause() {
    // Implement your code inside here

    print('HomeScreen is paused!');
  }

  void goAnotherScreen() {
    // Replace Navigator.push() or Navigator.pushNamed() with push() or pushNamed()

    push(context, MaterialPageRoute(builder: (context) => AnotherScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Another Screen'),
          onPressed: () {
            goAnotherScreen();
          },
        ),
      ),
    );
  }

  @override
  void emit(ViewEvent event) {
    // TODO: implement emit
  }
}

class AnotherScreen extends StatefulWidget {
  @override
  AnotherScreenState createState() => AnotherScreenState();
}

class AnotherScreenState extends ResumableState<AnotherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('aaa')
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go Back'),
          onPressed: () {
            goBack();
          },
        ),
      ),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }
}
//