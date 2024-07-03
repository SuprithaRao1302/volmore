import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:volmore/services/event_service.dart';

class LogNowScreen extends StatefulWidget {
  @override
  _LogNowScreenState createState() => _LogNowScreenState();
}

class _LogNowScreenState extends State<LogNowScreen> {
  bool _isChecked = false;
  String _location = '';
  late DateTime _startTime;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  String _locationName = 'Fetching location name...';
  String? title;
  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        title = ModalRoute.of(context)?.settings.arguments as String? ?? '';
      });
    });
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still in the tree.
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Cancel the timer to prevent it from firing after dispose.
    super.dispose();
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedTime = Duration.zero;
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = 'Location services are disabled.';
        _locationName = 'Unable to fetch location name';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = 'Location permissions are denied';
          _locationName = 'Unable to fetch location name';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location =
            'Location permissions are permanently denied, we cannot request permissions.';
        _locationName = 'Unable to fetch location name';
      });
      return;
    }

    // When we reach here, permissions are granted and we can continue.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1'));
    final locationName = jsonDecode(response.body)['display_name'];

// Use the location name as needed
    print(locationName); // Print the location name to the console.
    setState(() {
      _location = locationName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Log ${title} Now'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                '/home',
              );
            },
          )),
      body: Column(
        children: [
          CheckboxListTile(
            title: const Text('Get Location'),
            contentPadding: const EdgeInsets.all(2),
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
                if (_isChecked) {
                  _getLocation();
                } else {
                  _location = '';
                }
              });
            },
          ),
          Text(_location),
          const SizedBox(height: 20),
          const Text('Elapsed Time'),
          Text(
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              '${_elapsedTime.inHours.toString().padLeft(2, '0')}:${_elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Start'),
                onPressed: _startTimer,
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text('Reset'),
                onPressed: _resetTimer,
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text('Stop'),
                onPressed: _stopTimer,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Start Time'),
                  Text(
                    '${_startTime.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  const Text('End Time'),
                  Text('${_startTime.add(_elapsedTime).toString()}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                EventService()
                    .addLogEntry(title!, _location, _startTime,
                        _startTime.add(_elapsedTime))
                    .then((value) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Log saved successfully'))),
                          // Navigator.pop(context)
                        });
              },
              child: const Text('Save Log'))
        ],
      ),
    );
  }
}
