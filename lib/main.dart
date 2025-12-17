import 'package:flutter/material.dart';
import 'screen/splash.dart';
import 'services/notif_service.dart';

// --- TAMBAHAN WAJIB (Agar Alarm Tahu Waktu) ---
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// ----------------------------------------------

void main() async {
  // Pastikan binding flutter siap dulu
  WidgetsFlutterBinding.ensureInitialized();

  // --- MULAI TAMBAHAN CODE ---
  // Inisialisasi Data Waktu (PENTING BANGET)
  tz.initializeTimeZones();
  
  // Set Lokasi ke WIB (Jakarta)
  // Biarpun user di Bali/Papua, ini mencegah error "Location not found"
  try {
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  } catch (e) {
    print("Error setting location: $e");
  }
  // --- SELESAI TAMBAHAN CODE ---

  // Hidupkan Mesin Notifikasi (Punya kamu tetap dipakai)
  await NotifService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}