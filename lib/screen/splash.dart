import 'package:flutter/material.dart';
import 'task.dart'; // Pastikan import ke halaman utama (TaskPage)

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // WARNA DARK MODE (Sesuai tema aplikasi)
    final Color kBackground = const Color(0xFF1F1F1F);
    final Color kBlueGoogle = const Color(0xFF8AB4F8);
    final Color kTextWhite = const Color(0xFFE3E3E3);
    final Color kTextGrey = const Color(0xFFAAAAAA);

    return Scaffold(
      backgroundColor: kBackground, // Background Hitam
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // GAMBAR ILUSTRASI
              // Pastikan gambarnya transparan (PNG) agar menyatu dengan background gelap
              // Kalau gambarmu punya background hijau kotak, nanti akan terlihat kotak.
              // Jika belum ada gambar yang pas, saya ganti pakai Icon besar sementara.
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  // color: Colors.transparent, 
                ),
                child: Icon(
                  Icons.task_alt_rounded, // Icon Checklist Besar
                  size: 150,
                  color: kBlueGoogle,
                ),
                // Jika mau pakai gambar asetmu, hapus child Icon di atas dan pakai ini:
                // child: Image.asset("assets/welcome_image.png", fit: BoxFit.contain),
              ),
              
              const SizedBox(height: 40),

              // JUDUL
              Text(
                "WELCOME TO\nTASKIFY",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: kTextWhite, // Teks Putih
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 16),

              // SUBTITLE
              Text(
                "Plan your day and stay\nproductive",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: kTextGrey, // Teks Abu
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // TOMBOL GET STARTED
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Pindah ke Halaman Utama (TaskPage)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TaskPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBlueGoogle, // Tombol Biru
                    foregroundColor: const Color(0xFF1F1F1F), // Teks Tombol Hitam (Kontras)
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}