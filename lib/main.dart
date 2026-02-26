import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:wakeup/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(Wakeup());
}

class Wakeup extends StatelessWidget {
  const Wakeup({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xfffd4a3c),
        ),
      ),
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
