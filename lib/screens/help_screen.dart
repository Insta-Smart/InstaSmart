// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/components/page_top_bar.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PageTopBar(
          appBar: AppBar(),
          title: 'Help',
        ),
        body: Column(
          children: <Widget>[
            Text(
              'How To Use InstaSmart? Read more',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.amber[600],
                    child: const Center(child: Text('Explore')),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[500],
                    child: const Center(child: Text('Liked')),
                  ),
                  Container(
                      height: 50,
                      color: Colors.amber[100],
                      child: const Center(child: Text('My Grids'))),
                  Container(
                      height: 50,
                      color: Colors.amber[100],
                      child: const Center(child: Text('Creating Reminders'))),
                  Container(
                      height: 50,
                      color: Colors.amber[100],
                      child: const Center(
                          child: Text('Posting Directly To Instagram'))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
