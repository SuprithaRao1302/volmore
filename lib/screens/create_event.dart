import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volmore/services/event_service.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController hostController = TextEditingController();

  String _selectedFrequency = 'daily';
  Color _currentColor = Colors.blue;
  String? _selectedValue;
  List<Map<String, dynamic>> _groupList = [];

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _convertDocumentsToMap() async {
    final List<DocumentSnapshot> documents =
        await EventService().fetchAllGroups();

    List<Map<String, dynamic>> mapList = [];
    for (var document in documents) {
      Map<String, dynamic> map = {
        'name': document['name'],
        'color': document['color'],
      };
      mapList.add(map);
    }
    setState(() {
      _groupList = mapList;
    });
  }

  @override
  void initState() {
    super.initState();
    _convertDocumentsToMap();
  }

  void _changeColor(Color color) {
    print(color);
    setState(() {
      _currentColor = color;
    });
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a group'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: groupController,
                  decoration: const InputDecoration(
                    hintText: 'Enter group name',
                  ),
                ),
                BlockPicker(
                  pickerColor: _currentColor,
                  onColorChanged: _changeColor,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () async {
                await EventService().createGroup(
                  groupController.text,
                  '#${_currentColor.value.toRadixString(16)}',
                );
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                    msg: "Group created successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                _convertDocumentsToMap();
              },
            ),
          ],
        );
      },
    );
  }

  Color hexToColor(String hexString) {
    // Remove the # from the start if it is there
    String hexCode = hexString.replaceAll("#", "");
    return Color(int.parse(hexCode, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    // var _selectedGroup = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Title',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Enter title',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Host',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: hostController,
            decoration: const InputDecoration(
              hintText: 'Enter Host Name',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: 'Enter location',
            ),
          ),
          const SizedBox(height: 16.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_selectedDate == null
                  ? 'No date selected!'
                  : "Selected date: ${_selectedDate!.toLocal()}"),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select date'),
              ),
            ],
          ),
          const Text(
            'Date(s) & Recurrence',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<String>(
            value: _selectedFrequency,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFrequency = newValue!;
              });
            },
            items: <String>['Does not repeat', 'daily', 'weekly', 'custom']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Group',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement create group functionality
                },
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _openColorPicker();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _groupList.isEmpty
                    ? const CircularProgressIndicator() // Show a loading indicator while data is being fetched
                    : DropdownButton<String>(
                        hint: const Text('Select an option'),
                        value: _selectedValue,
                        items: _groupList.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> group) {
                          // Example assignment, ensure this happens before your widget                          print(colorr);
                          return DropdownMenuItem<String>(
                            value: group['name'],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  group['name'],
                                ),
                                const SizedBox(width: 8.0),
                                Container(
                                  width: 16.0,
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hexToColor(group['color']),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedValue = newValue;
                          });
                        },
                      ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await EventService().createEvent(
                      titleController.text,
                      locationController.text,
                      descriptionController.text,
                      hostController.text,
                      _selectedFrequency,
                      _selectedValue!,
                      _selectedDate!,
                    );
                  },
                  child: const Text('Submit'))
            ],
          ),
        ]),
      ),
    );
  }
}
