import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String studentId;
  final String name;
  final String studentClass;

  Student({required this.studentId, required this.name, required this.studentClass});

  factory Student.fromMap(Map<String, dynamic> data) {
    return Student(
      studentId: data['studentId'],
      name: data['name'],
      studentClass: data['class'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'class': studentClass,
    };
  }
}

class AttendanceRecord {
  final String studentId;
  final DateTime timestamp;

  AttendanceRecord({required this.studentId, required this.timestamp});

  factory AttendanceRecord.fromMap(Map<String, dynamic> data) {
    return AttendanceRecord(
      studentId: data['studentId'],
      timestamp: (data['timestamp'] as Timestamp).toDate(), // Make sure Timestamp is imported
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'timestamp': Timestamp.fromDate(timestamp), // Use Timestamp from the correct import
    };
  }
}
