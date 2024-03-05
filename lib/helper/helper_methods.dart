// return formatted data as a string

import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // convert timestamp to string
  DateTime dateTime = timestamp.toDate();

  // get year
  String year = dateTime.year.toString();

  // get month
  String month = dateTime.month.toString();

  // get day
  String day = dateTime.day.toString();

  // final formatted string
  String formattedData = '$day/$month/$year';

  return formattedData;
}
