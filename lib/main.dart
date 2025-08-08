import 'package:flutter/material.dart';

import 'screens/upcoming_matches_screen.dart';

void main() {
  runApp(const FootballIsLifeApp());
}

class FootballIsLifeApp extends StatelessWidget {
  const FootballIsLifeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football is Life',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const UpcomingMatchesScreen(),
    );
  }
}
