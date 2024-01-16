import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp){
  DateTime dateTime = timestamp.toDate();
  String year = dateTime.year.toString();
  String day = dateTime.day.toString();
  String month = dateTime.month.toString();
  String formattedDate = '$day/$month/$year';
  return formattedDate;
}