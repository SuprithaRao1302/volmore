import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:volmore/services/auth_service.dart';
import 'package:volmore/services/event_service.dart';
import 'package:intl/intl.dart';
import 'package:volmore/services/misc_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> events = [];
  List<DocumentSnapshot> groups = [];
  List<Map<String, dynamic>> eventList = [];
  List<Map<String, dynamic>> groupList = [];
  void getEvents() async {
    events = await EventService().fetchAllEvents();
    groups = await EventService().fetchAllGroups();

    for (var event in events) {
      Map<String, dynamic> map = {
        'title': event['title'],
        'date': event['date'],
        'host': event['host'],
        'status': event['status'],
        'groupName': event['groupName']
      };
      eventList.add(map);
    }
    for (var group in groups) {
      Map<String, dynamic> map = {
        'name': group['name'],
        'color': group['color'],
      };
      groupList.add(map);
    }
    setState(() {});
  }

  List<Map<String, dynamic>> getEventsByStatus(String status) {
    return eventList.where((event) => event['status'] == status).toList();
  }

  String? getColorByName(String name) {
    var group = groupList.firstWhere(
      (group) => group['name'] == name,
      orElse: () => {'name': 'null', 'color': 'null'},
    );
    return group['color'];
  }

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VolMore',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 128), fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'create_event',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/event_direct');
                      },
                      child: const Text('Create Event'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'transcript',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/transcript');
                      },
                      child: const Text('Transcript'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'log_out',
                    child: GestureDetector(
                        onTap: () {
                          AuthService().signOut();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Log Out')),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value == 'create_event') {
                  // Handle create event action
                } else if (value == 'log_out') {
                  // Handle log out action
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/log_past_event');
                },
                child: const Text('Start Logging',style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildEventSection('Today\'s Events', context, eventList),
                  buildEventSection('Upcoming Events', context, eventList),
                  buildEventSection('Past Events', context, eventList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isUpcoming(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  Widget buildEventSection(
      String title, BuildContext context, List<Map<String, dynamic>> events) {
    return Container(
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              TextStyle? textStyle;
              String? colorCode = getColorByName(event['groupName']);
              if (colorCode != "null") {
                textStyle = TextStyle(
                  color: Color(int.parse(colorCode!.replaceFirst('#', '0x'))),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                );
              } else {
                // Handle the case where colorCode is null, e.g., by using a default color
                textStyle = TextStyle(
                  color: Colors.black, // Default color
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                );
              }
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            MiscService.getFormattedDate(event['date']),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            event['title'],
                            style: textStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Host: ${event['host']}'),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Share'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Duplicate'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          title == 'Past Events'
                              ? ElevatedButton(
                                  onPressed: event['status']
                                      ? null
                                      : () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                            '/volunteer_confirmation',
                                            arguments: {
                                              'title': event['title'],
                                              'groupName': event['groupName'],
                                            },
                                          );
                                        },
                                  child: Text(
                                      event['status'] ? 'Verified' : 'Verify'),
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: title ==
                                              "Upcoming Events"
                                          ? WidgetStateProperty.all(Colors.grey)
                                          : WidgetStateProperty.all(
                                              Colors.blue)),
                                  onPressed: title == 'Today\'s Events'
                                      ? () {
                                          Navigator.of(context)
                                              .pushReplacementNamed('/log_now',
                                                  arguments: event['title']);
                                        }
                                      : null,
                                  child: const Text(
                                    'Log Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
