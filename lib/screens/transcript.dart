import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volmore/services/event_service.dart';
import 'package:volmore/services/misc_service.dart';

class TranscriptPage extends StatefulWidget {
  @override
  _TranscriptPageState createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  List<Map<dynamic, dynamic>> eventList = [];
  Future<void> getAllEvents() async {
    try {
      final List<DocumentSnapshot> groups =
          await EventService().fetchAllGroups();
      List<Map<dynamic, dynamic>> mapList = [];

      for (var group in groups) {
        // Fetch events for each group
        List<DocumentSnapshot>? documents =
            await EventService().fetchEventsByGroupName(group['name']);

        if (documents != null) {
          for (var document in documents) {
            // Initialize hours for each document
            if(document['status'] == false) continue;
            String hours = '0';

            // Check if logs exist and calculate total hours
            if ((document.data() as Map).containsKey('logs')) {
              document['logs'].forEach((log) {
                hours = MiscService.getTotalHours(
                    log); // Assuming this function calculates total hours
              });
            }

            // Create map for each document
            Map<dynamic, dynamic> map = {
              'title': document['title'],
              'location': document['location'],
              'date': document['date'],
              'host': document['host'],
              'hours': hours,
              'color': group['color'],
              'signature_status': document['signature_status'],
              'location_status': document['location_status'],
              'timer_status': document['timer_status'],
            };
            mapList.add(map);
          }
        }
      }

      setState(() {
        eventList.addAll(mapList);
      });
    } catch (e) {
      print('Error getting all events: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transcript'),
      ),
      body: ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          final item = eventList[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              tileColor: item['color'] != null
                  ? Color(int.parse(item['color'].replaceAll("#", "0x")))
                  : Colors.grey,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${MiscService.getFormattedDate(item['date'])}',style: TextStyle(color: Colors.white),),
                  Text('Host: ${item['host']} Hours: ${item['hours']}',style: TextStyle(color: Colors.white),),
                  Text('Location: ${item['location']}',style: TextStyle(color: Colors.white),),
                ],
              ),
              title: Text(item['title'],style: TextStyle(color: Colors.white),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  item['location_status'] == true
                      ? Icon(Icons.location_on, color: Colors.white)
                      : Icon(Icons.location_off, color: Colors.white),
                  SizedBox(width: 8),
                  item['signature_status'] == true
                      ? Icon(Icons.draw, color: Colors.white)
                      : Icon(Icons.close, color: Colors.white),
                  SizedBox(width: 8),
                  item['timer_status'] == true
                      ? Icon(Icons.timer, color: Colors.white)
                      : Icon(Icons.timer_off, color: Colors.white),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
