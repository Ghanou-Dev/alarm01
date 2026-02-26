import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakeup/pages/alarm_screen.dart';
import 'package:wakeup/permission_helper.dart';
import 'package:wakeup/widgets/alarm_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AlarmSettings> alarms = [];
  StreamSubscription<AlarmSet>? alarmSubscription;

  @override
  void initState() {
    super.initState();
    checkPermissions();
    loadAlarms();
    alarmSubscription ??= Alarm.ringing.listen((AlarmSet alarmSet) {
      for (final alarm in alarmSet.alarms) {
        // yourOnRingCallback
        navigatToAlarmScreen(alarm);
      }
    });
  }

  // open with |auto start settings ////////////////////////////////////////////
  Future<void> openAutoStartSettings() async {
    // من اجل العمل في الخلفية //
    var isAvailabel = await isAutoStartAvailable;
    if (isAvailabel == true) {
      await getAutoStartPermission();
    }
  }

  // open with |app settings ///////////////////////////////////////////////////
  Future<void> opentAppSettings() async {
    await AppSettings.openAppSettings(
      type: AppSettingsType.settings,
    );
  }

  //////////////////////////////////////////////////////////////////////////////

  // stop alarm ////////////////////////////////////////////////////////////////
  Future<void> stopAlarm({required int id}) async {
    await Alarm.stop(id);
    await loadAlarms();
  }

  // set alarm /////////////////////////////////////////////////////////////////
  Future<void> setAlarm({
    required String audioPath,
  }) async {
    // set time ////////////////////////////////////////////////////////////////
    DateTime now = DateTime.now();
    DateTime alarmTime = now.add(Duration(seconds: 30));
    // set Alarm Settings //////////////////////////////////////////////////////
    AlarmSettings alarmSettings = AlarmSettings(
      dateTime: alarmTime,
      id: now.millisecondsSinceEpoch ~/ 1000,
      assetAudioPath: audioPath,
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
      payload: 'simple alarm',
      notificationSettings: NotificationSettings(
        title: "WakeUp Goon",
        body: "You have to build your self",
        stopButton: 'Stop',
        icon: 'notification_icon',
        iconColor: Color(0xfffd4a3c),
      ),
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: Duration(seconds: 5),
        volumeEnforced: true,
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
    await loadAlarms();
  }

  // navigat to alarm screen ///////////////////////////////////////////////////
  void navigatToAlarmScreen(AlarmSettings alarm) async {
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (context) => AlarmScreen(
          alarmSettings: alarm,
        ),
      ),
    );
    await loadAlarms();
  }

  // load alarms ///////////////////////////////////////////////////////////////
  Future<void> loadAlarms() async {
    if (!mounted) return;
    List<AlarmSettings> loadAlarms = await Alarm.getAlarms();
    loadAlarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    setState(
      () {
        alarms = loadAlarms;
      },
    );
  }

  // check permission //////////////////////////////////////////////////////////
  Future<void> checkPermissions() async {
    if (!mounted) return;
    if (Platform.isAndroid) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    debugPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      debugPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      debugPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    alarmSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3e5eb),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setAlarm(
            audioPath: 'assets/sounds/alarm.mp3',
          );
        },
        child: Icon(
          Icons.add,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height / 3.6,
              width: size.width,
              decoration: BoxDecoration(
                color: Color(0xffe3e5eb),
              ),
              child: Image.asset('assets/images/Clock.png'),
            ),
            ElevatedButton(
              onPressed: () async {
                // go to notification settings [ with nativ code platform channel ]
                await PermissionsHelper.openOverlaySettings();
              },
              style: ElevatedButton.styleFrom(
                shape: LinearBorder(),
              ),
              child: Text(
                'Go to open auto start settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffe3e5eb),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 0.1,
                      color: Colors.blueGrey.shade300,
                    ),
                  ],
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Alarms',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontFamily: 'poppins',
                              fontSize: 18,
                              color: Color(0xff646e82),
                            ),
                          ),
                          Spacer(),
                          PopupMenuButton(
                            iconColor: Color(0xff646e82),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                child: Text('more'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: alarms.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AlarmItem(
                              alarmSettings: alarms[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
