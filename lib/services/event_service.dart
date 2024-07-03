import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final CollectionReference _groupsCollection =
      FirebaseFirestore.instance.collection('Groups');

  Future<List<DocumentSnapshot>> fetchAllGroups() async {
    QuerySnapshot querySnapshot = await _groupsCollection.get();
    return querySnapshot.docs;
  }

  Future<void> createGroup(String name, String color) async {
    await _groupsCollection.doc(name).set({
      'name': name,
      'color': color,
    });
  }

  Future<void> createEvent(String title, String location, String description,
      String host, String recurrence, String groupName, DateTime date) async {
    await FirebaseFirestore.instance.collection('Events').add({
      'title': title,
      'location': location,
      'description': description,
      'recurrence': recurrence,
      'groupName': groupName,
      'host': host,
      'status': false,
      'date': date,
      'logs': [],
      'location_status': false,
      'timer_status': false,
      'signature_status': false,
      'hours': '0'
    });
  }

  Future<List<DocumentSnapshot>> fetchAllEvents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Events').get();
    return querySnapshot.docs;
  }

  Future<String?> getDocumentIdByTitle(
      String collection, String key, String value) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where(key, isEqualTo: value)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        print('No document found in $collection with title: $value');
        return null;
      }
    } catch (e) {
      print('Error getting document ID: $e');
      return null;
    }
  }

  /// Fetches a document by the given name.
  /// Returns the fetched document if found, or null if the document does not exist.
  Future<DocumentSnapshot?> fetchDocumentByName(String name) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where('title', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        print('No document found with name: $name');
        return null;
      }
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }

  Future<void> addLogEntry(String title, String location, DateTime startTime,
      DateTime endTime) async {
    try {
      String? documentId = await getDocumentIdByTitle('Events', 'title', title);
      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('Events').doc(documentId);

      Map<String, dynamic> newLog = {
        'location': location,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
      };

      await documentReference.update({
        'timer_status': true,
        'location_status': true,
        'logs': FieldValue.arrayUnion([newLog])
      });

      print('Log entry added successfully');
    } catch (e) {
      print('Error adding log entry: $e');
    }
  }

  Future<void> updateEventStatus(String title, bool status) async {
    try {
      String? documentId = await getDocumentIdByTitle('Events', 'title', title);
      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('Events').doc(documentId);

      await documentReference.update({
        'status': status,
        'signature_status': status,
      });

      print('Event status updated successfully');
    } catch (e) {
      print('Error updating event status: $e');
    }
  }

  Future<List<DocumentSnapshot>?> fetchEventsByGroupName(
       String groupName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where('groupName', isEqualTo: groupName)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching events by group name: $e');
      return null;
    }
  }
}
