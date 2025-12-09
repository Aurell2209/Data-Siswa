import 'package:aplikasi_tugas1/data_menu_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lia Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 248, 153, 252),
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}

// Text HalamanUtama
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "FilmKuu",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   actions: const [
      //     Padding(
      //       padding: EdgeInsets.only(right: 15.0),
      //       child: Icon(Icons.search),
      //     ),
      //   ],
      //   backgroundColor: const Color.fromARGB(255, 130, 143, 255),
      // ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Icon(
                  Icons.school,
                  size: 300,
                  color: Color.fromARGB(255, 27, 62, 188),
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "DATAKU",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 80,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 50.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HalamanKedua(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                27,
                                62,
                                188,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "                         Selanjutnya                        ",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
