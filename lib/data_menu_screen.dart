import 'package:flutter/material.dart';
import 'package:aplikasi_tugas1/datasiswa.dart';

class HalamanKedua extends StatelessWidget {
  const HalamanKedua({super.key});

  static const List<Map<String, dynamic>> menuItems = [
    {'title': 'Data Siswa', 'destination': HalamanKetiga()},
    {'title': 'Data Guru', 'destination': HalamanKetiga()},
    {'title': 'Data Pegawai', 'destination': HalamanKetiga()},
    {'title': 'Data OB', 'destination': HalamanKetiga()},
  ];

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    Widget destination,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D255A),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 120,
        backgroundColor: const Color(0xFF0D255A),
        centerTitle: true,
        title: const Text(
          'DATAKU',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 30),

            ...menuItems.map((item) {
              return _buildMenuButton(
                context,
                item['title'] as String,
                item['destination'] as Widget,
              );
            }).toList(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
