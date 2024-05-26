class ConvertTimeZone {
  final String? fromTimezone;
  final String? fromDateTime;
  final String? toTimeZone;
  final ConversionResult? conversionResult;

  ConvertTimeZone({
    this.fromTimezone,
    this.fromDateTime,
    this.toTimeZone,
    this.conversionResult,
  });

  ConvertTimeZone.fromJson(Map<String, dynamic> json)
      : fromTimezone = json['fromTimezone'] as String?,
        fromDateTime = json['fromDateTime'] as String?,
        toTimeZone = json['toTimeZone'] as String?,
        conversionResult = (json['conversionResult'] as Map<String,dynamic>?) != null ? ConversionResult.fromJson(json['conversionResult'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'fromTimezone' : fromTimezone,
    'fromDateTime' : fromDateTime,
    'toTimeZone' : toTimeZone,
    'conversionResult' : conversionResult?.toJson()
  };
}

class ConversionResult {
  final int? year;
  final int? month;
  final int? day;
  final int? hour;
  final int? minute;
  final int? seconds;
  final int? milliSeconds;
  final String? dateTime;
  final String? date;
  final String? time;
  final String? timeZone;
  final bool? dstActive;

  ConversionResult({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.seconds,
    this.milliSeconds,
    this.dateTime,
    this.date,
    this.time,
    this.timeZone,
    this.dstActive,
  });

  ConversionResult.fromJson(Map<String, dynamic> json)
      : year = json['year'] as int?,
        month = json['month'] as int?,
        day = json['day'] as int?,
        hour = json['hour'] as int?,
        minute = json['minute'] as int?,
        seconds = json['seconds'] as int?,
        milliSeconds = json['milliSeconds'] as int?,
        dateTime = json['dateTime'] as String?,
        date = json['date'] as String?,
        time = json['time'] as String?,
        timeZone = json['timeZone'] as String?,
        dstActive = json['dstActive'] as bool?;

  Map<String, dynamic> toJson() => {
    'year' : year,
    'month' : month,
    'day' : day,
    'hour' : hour,
    'minute' : minute,
    'seconds' : seconds,
    'milliSeconds' : milliSeconds,
    'dateTime' : dateTime,
    'date' : date,
    'time' : time,
    'timeZone' : timeZone,
    'dstActive' : dstActive
  };
}