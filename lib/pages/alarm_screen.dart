import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const AlarmScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 238, 243),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height / 3,
              width: size.width,
              decoration: BoxDecoration(
                color: Color(0xffeceef3),
              ),
              child: Image.asset('assets/images/Clock.png'),
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
            ElevatedButton(
              onPressed: () async {
                await Alarm.stop(widget.alarmSettings.id);
                Navigator.of(context).pop();
              },
              child: Text(
                'Stop',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
