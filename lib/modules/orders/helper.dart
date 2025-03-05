String getMonthName(int month) {
  const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}

String formatHour(int hour) {
  int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
  return formattedHour.toString();
}

String formatMinute(int minute) {
  return minute.toString().padLeft(2, '0');
}

String getAmPm(int hour) {
  return hour >= 12 ? "PM" : "AM";
}
