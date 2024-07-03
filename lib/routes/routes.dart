import 'package:flutter/material.dart';
import 'package:volmore/screens/create_event.dart';
import 'package:volmore/screens/event_direct.dart';
import 'package:volmore/screens/forgot_password.dart';
import 'package:volmore/screens/home.dart';
import 'package:volmore/screens/log_now.dart';
import 'package:volmore/screens/log_past_event.dart';
import 'package:volmore/screens/login.dart';
import 'package:volmore/screens/register.dart';
import 'package:volmore/screens/transcript.dart';
import 'package:volmore/screens/volunteer_confirmation.dart';
Map<String, WidgetBuilder> getRoutes() {
  return {
    // Add routes here
    '/home': (context) =>  HomeScreen(),
    '/login': (context) =>  LoginScreen(),
    '/register': (context) =>  RegisterPage(),
    '/forgot_password': (context) =>  ForgotPasswordScreen(),
    '/event_direct': (context) =>  EventDirectPage(),
    '/create_event': (context) =>  CreateEventScreen(),
    '/log_now': (context) =>  LogNowScreen(),
    '/log_past_event': (context) =>  LogPastEventScreen(),
    '/volunteer_confirmation': (context) =>  VolunteerConfirmationPage(),
    '/transcript': (context) =>  TranscriptPage(),
  };
  }