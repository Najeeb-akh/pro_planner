import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pro_planner/theme/theme_notifier.dart';
void main() {
  runApp(MyApp_test());
}

class MyApp_test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button in the Middle'),
      ),
      body: Center(
        child: 
                             SwitchListTile(
            title: Text('Dark Mode'),
            value: Provider.of<ThemeNotifier>(context).isDarkMode,
            onChanged: (bool value) {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
        //   ),
        // ElevatedButton(
        //   onPressed: () {
        //     // Add your onPressed code here!
        //   },
        //   child: Text('Press Me'),
        ),
      ),
    );

  }
}