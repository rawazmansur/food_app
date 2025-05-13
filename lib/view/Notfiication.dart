import 'package:flutter/material.dart';
import 'package:food/view/widgets/lib/view/widgets/CustomBottomNavigationBar.dart';

class Notfiication extends StatefulWidget {
  const Notfiication({super.key});

  @override
  State<Notfiication> createState() => _NotfiicationState();
}

class _NotfiicationState extends State<Notfiication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification'),
      centerTitle: true,),
      body: Center(
        child:  ElevatedButton(
              onPressed: () {
                // NotificationService.showInstantNotification(
                //     "Instant Notification", "This shows an instant notifications");
              },
              child: const Text('Show Notification'
              ),
            ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
      ), // Assuming you have this widget
    );
  }
}