import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int totalTime = 0; // Total waktu yang dihitung dalam detik
  int hours = 0; // Waktu jam
  int minutes = 0; // Waktu menit
  int seconds = 0; // Waktu detik
  bool isActive = false; // Status timer aktif atau tidak
  late Timer timer; // Timer untuk menghitung waktu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              _formatDuration(Duration(seconds: totalTime)),
              style: TextStyle(fontSize: 64.0),
            ),
          ),
          SizedBox(height: 20.0),
          if (!isActive)
            Column(
              children: [
                _buildTimeInput('Jam', (value) {
                  hours = int.parse(value);
                }),
                SizedBox(height: 10.0),
                _buildTimeInput('Menit', (value) {
                  minutes = int.parse(value);
                }),
                SizedBox(height: 10.0),
                _buildTimeInput('Detik', (value) {
                  seconds = int.parse(value);
                }),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (!isActive && (hours > 0 || minutes > 0 || seconds > 0)) {
                      setState(() {
                        totalTime = (hours * 3600) + (minutes * 60) + seconds;
                        _startTimer(); // Memulai timer ketika tombol ditekan
                      });
                    }
                  },
                  child: Text('Set Waktu'),
                ),
              ],
            ),
          SizedBox(height: 20.0),
          if (isActive)
            ElevatedButton(
              onPressed: _pauseTimer, // Menjeda timer ketika tombol ditekan
              child: Text('Pause'),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.grey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '222410102052 - Rama Maulana',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun input waktu
  Widget _buildTimeInput(String label, void Function(String) onChanged) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memulai timer
  void _startTimer() {
    if (!isActive && totalTime > 0) {
      setState(() {
        isActive = true; // Set timer menjadi aktif
      });
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (totalTime <= 0) {
            timer.cancel();
            isActive = false; // Set timer menjadi tidak aktif
            _showAlertDialog(); // Tampilkan dialog waktu habis
          } else {
            totalTime--; // Kurangi total waktu
          }
        });
      });
    }
  }

  // Fungsi untuk menjeda timer
  void _pauseTimer() {
    if (isActive) {
      timer.cancel(); // Batalkan timer
      setState(() {
        isActive = false; // Set timer menjadi tidak aktif
      });
    }
  }

  // Fungsi untuk menghentikan timer dan mengatur ulang waktu
  void _restartTimer() {
    timer.cancel(); // Batalkan timer
    setState(() {
      totalTime = 0; // Set total waktu menjadi 0
      isActive = false; // Set timer menjadi tidak aktif
    });
  }

  // Fungsi untuk memformat durasi waktu
  String _formatDuration(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  // Fungsi untuk menampilkan dialog waktu habis
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text('Peringatan'),
          content: Text('Waktu telah habis!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _restartTimer(); // Mengatur ulang timer
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }
}
