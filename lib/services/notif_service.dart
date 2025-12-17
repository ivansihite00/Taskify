import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi (Sudah kamu panggil di main.dart)
  static Future<void> init() async {
    tz.initializeTimeZones(); // Pastikan timezone jalan
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // --- FUNGSI BARU: JADWALKAN TUGAS ---
  static Future<void> scheduleNotification(int id, String title, DateTime scheduledTime) async {
    // 1. Konversi waktu ke Timezone Lokal
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Cek: Kalau waktunya sudah lewat, jangan dijadwalkan (biar ga error)
    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      print("Waktu sudah lewat, alarm tidak dipasang.");
      return;
    }

    // 2. Minta Izin (Android 13+)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // 3. Pasang Alarm
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // ID Unik dari Tugas
      'Reminder: $title', // Judul Notif
      'Waktunya mengerjakan tugas ini!', // Isi Pesan
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'taskify_channel', 
          'Taskify Reminder',
          channelDescription: 'Channel untuk pengingat tugas',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Wajib biar bunyi pas layar mati
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("✅ Alarm berhasil diset untuk: $tzScheduledTime");
  }
}