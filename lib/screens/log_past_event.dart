import 'package:flutter/material.dart';

class LogPastEventScreen extends StatefulWidget {
  @override
  _LogPastEventScreenState createState() => _LogPastEventScreenState();
}

class _LogPastEventScreenState extends State<LogPastEventScreen> {
  List<DateTime> selectedDates = [];
  List<TimeOfDay> selectedStartTimes = [];
  List<TimeOfDay> selectedEndTimes = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Past Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Date and Time'),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: selectedDates.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text('Date ${index + 1}'),
                      Text(selectedDates[index].toString()),
                      SizedBox(height: 8.0),
                      Text('Start Time'),
                      Text(selectedStartTimes[index].toString()),
                      SizedBox(height: 8.0),
                      Text('End Time'),
                      Text(selectedEndTimes[index].toString()),
                      SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((selectedStartTime) {
                        if (selectedStartTime != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectedEndTime) {
                            if (selectedEndTime != null) {
                              setState(() {
                                selectedDates.add(selectedDate);
                                selectedStartTimes.add(selectedStartTime);
                                selectedEndTimes.add(selectedEndTime);
                              });
                            }
                          });
                        }
                      });
                    }
                  });
                },
                child: Text('Add Date and Time'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement submit logic here
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}