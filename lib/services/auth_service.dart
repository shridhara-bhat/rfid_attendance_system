import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signup
  Future<bool> signUp(String studentId, String password, String name, String studentClass) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: '$studentId@example.com',
        password: password,
      );
      //storeindatabase
      await _firestore.collection('students').doc(studentId).set({
        'studentId': studentId,
        'name': name,
        'class': studentClass,
      });

      return true;
    } catch (e) {
      print('Sign up failed: $e');
      return false; 
    }
  }

  Future<bool> signIn(String studentId, String password) async {//signin
    try {
      await _auth.signInWithEmailAndPassword(
        email: '$studentId@example.com',
        password: password,
      );
      return true; 
    } catch (e) {
      print('Sign in failed: $e');
      return false;
    }
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //attendance
  Future<List<Map<String, dynamic>>> fetchAttendance(String studentId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('attendance')
          .where('studentId', isEqualTo: studentId)
          .get();

      List<Map<String, dynamic>> attendanceRecords = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
        record['id'] = doc.id;

        List<DateTime> timestamps = [];
        record.forEach((key, value) {
          if (key.startsWith('timestamp_')) {
            timestamps.add((value as Timestamp).toDate());
          }
        });

        if (timestamps.isNotEmpty) {
          attendanceRecords.add({'id': doc.id, 'timestamps': timestamps});
        }
      }

      return attendanceRecords;
    } catch (e) {
      print('Error fetching attendance: $e');
      return [];
    }
  }

  // Fetch student data
  Future<Map<String, dynamic>?> fetchStudentData(String studentId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('students').doc(studentId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching student data: $e');
      return null;
    }
  }
}
