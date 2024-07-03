import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';

import 'package:volmore/services/event_service.dart';
import 'package:volmore/services/misc_service.dart'; // For Uint8List

class VolunteerConfirmationPage extends StatefulWidget {
  @override
  State<VolunteerConfirmationPage> createState() =>
      _VolunteerConfirmationPageState();
}

class _VolunteerConfirmationPageState extends State<VolunteerConfirmationPage> {
  String? title, groupName;
  List<Map<dynamic, dynamic>> eventList = [];
  bool allEvent = false;
  String hours='';
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  Map<String, dynamic> documentData = {};
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          title = args['title'] ?? '';
          groupName = args['groupName'] ?? '';
        });
        getDocument(title!, groupName!);
      }
    });
  }

  Future<void> getDocument(String title, String groupName) async {
    DocumentSnapshot<Object?>? snapshot =
        await EventService().fetchDocumentByName(title);
    if (snapshot!.exists) {
      setState(() {
        documentData = snapshot.data() as Map<String, dynamic>;
      });
// Assuming documentData is your Firestore document containing 'logs'
      if (documentData['logs'] != null) {
        documentData['logs'].forEach((log) {
         hours = MiscService.getTotalHours(log);
        });
      }
      List<DocumentSnapshot>? documents =
          await EventService().fetchEventsByGroupName( groupName);
      List<Map<dynamic, dynamic>> mapList = [];
      for (var document in documents!) {
        if (document['title'] == title) continue;
        Map<dynamic, dynamic> map = {
          'title': document['title'],
          'signature_status': document['signature_status'],
          'location_status': document['location_status'],
          'timer_status': document['timer_status'],
        };
        mapList.add(map);
      }
      setState(() {
        eventList = mapList;
      });
    } else {
      print('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Volunteer Confirmation'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                '/home',
              );
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Volunteer Confirmation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text('Event'),
              subtitle: Text('$title'),
            ),
            ListTile(
              title: const Text('Hours'),
              subtitle: Text(hours),
            ),
            ListTile(
              title: const Text('Signature'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    child: Signature(
                      controller: _controller,
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_controller.isNotEmpty) {
                        final Uint8List? data = await _controller.toPngBytes();
                        // Use this data as needed

                      }
                    },
                    child: const Text('Save Signature'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    child: const Text('Clear Signature'),
                  ),
                ],
              ),
            ),
            const ListTile(
              title: Text('Request Signature via.. '),
              subtitle: Row(
                children: [
                  Icon(Icons.mail),
                  Icon(Icons.message),
                  Icon(Icons.facebook)
                ],
              ),
            ),
            CheckboxListTile(
              title: const Text('Sign for all previous events'),
              value: false,
              onChanged: (value) {
                setState(() {
                  allEvent = value!;
                });
              },
            ),
            const Divider(),
            const ListTile(
              title: Text('Event Name'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Location'),
                  SizedBox(width: 16),
                  Text('Signature'),
                  SizedBox(width: 16),
                  Text('Timer'),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                final event = eventList[index];
                return ListTile(
                  title: Text(event['title']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: event['location_status'] == true
                              ? Icon(Icons.location_on)
                              : Icon(Icons.location_off)),
                      const SizedBox(width: 20),
                      Flexible(
                          child: event['signature_status'] == true
                              ? Icon(Icons.draw)
                              : Icon(Icons.close)),
                      const SizedBox(width: 20),
                      Flexible(
                          child: event['timer_status'] == true
                              ? Icon(Icons.timer)
                              : Icon(Icons.timer_off)),
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async{
                if (allEvent){
                  // Sign for all events
                  for (var event in eventList) {
                   await EventService().updateEventStatus(event['title'], allEvent);
                  }
                  SnackBar(content: Text('All events signed successfully'));
                }
                else {
                  // Sign for current event
                  await EventService().updateEventStatus(title!, true);
                  SnackBar(content: Text('Event signed successfully'));
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
