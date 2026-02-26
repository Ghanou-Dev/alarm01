import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmItem extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const AlarmItem({super.key, required this.alarmSettings});

  @override
  State<AlarmItem> createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> {
  bool isActiv = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffeaecf2),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade200,
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset.fromDirection(0.9, 0.9),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '${widget.alarmSettings.dateTime.hour}:${widget.alarmSettings.dateTime.minute}',
              style: TextStyle(
                // fontFamily: 'poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xff646e82),
                fontSize: 30,
              ),
            ),
            Spacer(),
            Text('Mon, 14 Dec', style: TextStyle(fontSize: 12)),
            Switch(
              activeTrackColor: Color(0xfffd4a3c),
              value: isActiv,
              onChanged: (value) {
                setState(() async {
                  isActiv = value;
                  if (isActiv) {
                    await Alarm.stop(widget.alarmSettings.id);
                  } else {
                    final now = DateTime.now();
                    if (widget.alarmSettings.dateTime.isBefore(now)) {
                      await Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                          dateTime: now.add(
                            Duration(seconds: 30),
                          ),
                        ),
                      );
                    } else {
                      await Alarm.set(alarmSettings: widget.alarmSettings);
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
