String todaysDateYYYYMMDD() {
  //today
  var dataTimeObject = DateTime.now();
  // year in the format yyyy
  String year = dataTimeObject.year.toString();

// month in the format mm
  String month = dataTimeObject.month.toString();

  if (month.length == 1) {
    month = '0$month';
  }
// day in the format dd

  String day = dataTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  //final formate
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

//convert string yyyymmdd to DateTime object
DateTime CreateDateTimeOblect(String yyymmdd) {
  int yyyy = int.parse(yyymmdd.substring(0, 4));
  int mm = int.parse(yyymmdd.substring(4, 6));
  int dd = int.parse(yyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// convert DateTime Object to String yyyymmdd

String convertDateTimeYYYYMMDD(DateTime date) {
  //today
  var dataTimeObject = DateTime.now();
  // year in the format yyyy
  String year = dataTimeObject.year.toString();

// month in the format mm
  String month = dataTimeObject.month.toString();

  if (month.length == 1) {
    month = '0$month';
  }
// day in the format dd

  String day = dataTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  //final formate
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
