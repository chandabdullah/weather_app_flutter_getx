WeatherModel weatherModelFromJson(Map<String, dynamic> str) =>
    WeatherModel.fromJson((str));

Map<String, dynamic> weatherModelToJson(WeatherModel data) => (data.toJson());

class WeatherModel {
  double? lat;
  double? lon;
  String? timezone;
  int? timezoneOffset;
  Current? current;
  List<Minutely>? minutely;
  List<Current>? hourly;
  List<Daily>? daily;
  List<Alert>? alerts;

  WeatherModel({
    this.lat,
    this.lon,
    this.timezone,
    this.timezoneOffset,
    this.current,
    this.minutely,
    this.hourly,
    this.daily,
    this.alerts,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        timezone: json["timezone"],
        timezoneOffset: json["timezone_offset"],
        current:
            json["current"] == null ? null : Current.fromJson(json["current"]),
        minutely: json["minutely"] == null
            ? []
            : List<Minutely>.from(
                json["minutely"]!.map((x) => Minutely.fromJson(x))),
        hourly: json["hourly"] == null
            ? []
            : List<Current>.from(
                json["hourly"]!.map((x) => Current.fromJson(x))),
        daily: json["daily"] == null
            ? []
            : List<Daily>.from(json["daily"]!.map((x) => Daily.fromJson(x))),
        alerts: json["alerts"] == null
            ? []
            : List<Alert>.from(json["alerts"]!.map((x) => Alert.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "timezone": timezone,
        "timezone_offset": timezoneOffset,
        "current": current?.toJson(),
        "minutely": minutely == null
            ? []
            : List<dynamic>.from(minutely!.map((x) => x.toJson())),
        "hourly": hourly == null
            ? []
            : List<dynamic>.from(hourly!.map((x) => x.toJson())),
        "daily": daily == null
            ? []
            : List<dynamic>.from(daily!.map((x) => x.toJson())),
        "alerts": alerts == null
            ? []
            : List<dynamic>.from(alerts!.map((x) => x.toJson())),
      };
}

class Alert {
  String? senderName;
  String? event;
  int? start;
  int? end;
  String? description;
  List<String>? tags;

  Alert({
    this.senderName,
    this.event,
    this.start,
    this.end,
    this.description,
    this.tags,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        senderName: json["sender_name"],
        event: json["event"],
        start: json["start"],
        end: json["end"],
        description: json["description"],
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sender_name": senderName,
        "event": event,
        "start": start,
        "end": end,
        "description": description,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
      };
}

class Current {
  int? dt;
  int? sunrise;
  int? sunset;
  double? temp;
  double? feelsLike;
  int? pressure;
  int? humidity;
  double? dewPoint;
  double? uvi;
  int? clouds;
  int? visibility;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;
  double? pop;
  Rain? rain;
  Rain? snow;

  Current({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.pop,
    this.rain,
    this.snow,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        dt: json["dt"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        temp: json["temp"]?.toDouble(),
        feelsLike: json["feels_like"]?.toDouble(),
        pressure: json["pressure"],
        humidity: json["humidity"],
        dewPoint: json["dew_point"]?.toDouble(),
        uvi: json["uvi"]?.toDouble(),
        clouds: json["clouds"],
        visibility: json["visibility"],
        windSpeed: json["wind_speed"]?.toDouble(),
        windDeg: json["wind_deg"],
        windGust: json["wind_gust"]?.toDouble(),
        weather: json["weather"] == null
            ? []
            : List<Weather>.from(
                json["weather"]!.map((x) => Weather.fromJson(x))),
        pop: json["pop"]?.toDouble(),
        rain: json["rain"] == null ? null : Rain.fromJson(json["rain"]),
        snow: json["snow"] == null ? null : Rain.fromJson(json["snow"]),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "sunrise": sunrise,
        "sunset": sunset,
        "temp": temp,
        "feels_like": feelsLike,
        "pressure": pressure,
        "humidity": humidity,
        "dew_point": dewPoint,
        "uvi": uvi,
        "clouds": clouds,
        "visibility": visibility,
        "wind_speed": windSpeed,
        "wind_deg": windDeg,
        "wind_gust": windGust,
        "weather": weather == null
            ? []
            : List<dynamic>.from(weather!.map((x) => x.toJson())),
        "pop": pop,
        "rain": rain?.toJson(),
        "snow": snow?.toJson(),
      };
}

class Rain {
  double? the1H;

  Rain({
    this.the1H,
  });

  factory Rain.fromJson(Map<String, dynamic> json) => Rain(
        the1H: json["1h"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "1h": the1H,
      };
}

class Weather {
  int? id;
  Main? main;
  Description? description;
  String? icon;

  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: mainValues.map[json["main"]]!,
        description: descriptionValues.map[json["description"]]!,
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": mainValues.reverse[main],
        "description": descriptionValues.reverse[description],
        "icon": icon,
      };
}

enum Description {
  BROKEN_CLOUDS,
  CLEAR_SKY,
  FEW_CLOUDS,
  LIGHT_RAIN,
  MODERATE_RAIN,
  OVERCAST_CLOUDS,
  SCATTERED_CLOUDS
}

final descriptionValues = EnumValues(
  {
    "broken clouds": Description.BROKEN_CLOUDS,
    "clear sky": Description.CLEAR_SKY,
    "few clouds": Description.FEW_CLOUDS,
    "light rain": Description.LIGHT_RAIN,
    "moderate rain": Description.MODERATE_RAIN,
    "overcast clouds": Description.OVERCAST_CLOUDS,
    "scattered clouds": Description.SCATTERED_CLOUDS
  },
  {
    Description.BROKEN_CLOUDS: "broken clouds",
    Description.CLEAR_SKY: "clear sky",
    Description.FEW_CLOUDS: "few clouds",
    Description.LIGHT_RAIN: "light rain",
    Description.MODERATE_RAIN: "moderate rain",
    Description.OVERCAST_CLOUDS: "overcast clouds",
    Description.SCATTERED_CLOUDS: "scattered clouds"
  },
);

enum Main { CLEAR, CLOUDS, RAIN }

final mainValues = EnumValues(
  {"Clear": Main.CLEAR, "Clouds": Main.CLOUDS, "Rain": Main.RAIN},
  {Main.CLEAR: "Clear", Main.CLOUDS: "Clouds", Main.RAIN: "Rain"},
);

class Daily {
  int? dt;
  int? sunrise;
  int? sunset;
  int? moonrise;
  int? moonset;
  double? moonPhase;
  String? summary;
  Temp? temp;
  FeelsLike? feelsLike;
  int? pressure;
  int? humidity;
  double? dewPoint;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;
  int? clouds;
  double? pop;
  double? rain;
  double? uvi;

  Daily({
    this.dt,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.summary,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.clouds,
    this.pop,
    this.rain,
    this.uvi,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        dt: json["dt"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        moonrise: json["moonrise"],
        moonset: json["moonset"],
        moonPhase: json["moon_phase"]?.toDouble(),
        summary: json["summary"],
        temp: json["temp"] == null ? null : Temp.fromJson(json["temp"]),
        feelsLike: json["feels_like"] == null
            ? null
            : FeelsLike.fromJson(json["feels_like"]),
        pressure: json["pressure"],
        humidity: json["humidity"],
        dewPoint: json["dew_point"]?.toDouble(),
        windSpeed: json["wind_speed"]?.toDouble(),
        windDeg: json["wind_deg"],
        windGust: json["wind_gust"]?.toDouble(),
        weather: json["weather"] == null
            ? []
            : List<Weather>.from(
                json["weather"]!.map((x) => Weather.fromJson(x))),
        clouds: json["clouds"],
        pop: json["pop"]?.toDouble(),
        rain: json["rain"]?.toDouble(),
        uvi: json["uvi"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "sunrise": sunrise,
        "sunset": sunset,
        "moonrise": moonrise,
        "moonset": moonset,
        "moon_phase": moonPhase,
        "summary": summary,
        "temp": temp?.toJson(),
        "feels_like": feelsLike?.toJson(),
        "pressure": pressure,
        "humidity": humidity,
        "dew_point": dewPoint,
        "wind_speed": windSpeed,
        "wind_deg": windDeg,
        "wind_gust": windGust,
        "weather": weather == null
            ? []
            : List<dynamic>.from(weather!.map((x) => x.toJson())),
        "clouds": clouds,
        "pop": pop,
        "rain": rain,
        "uvi": uvi,
      };
}

class FeelsLike {
  double? day;
  double? night;
  double? eve;
  double? morn;

  FeelsLike({
    this.day,
    this.night,
    this.eve,
    this.morn,
  });

  factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
        day: json["day"]?.toDouble(),
        night: json["night"]?.toDouble(),
        eve: json["eve"]?.toDouble(),
        morn: json["morn"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "night": night,
        "eve": eve,
        "morn": morn,
      };
}

class Temp {
  double? day;
  double? min;
  double? max;
  double? night;
  double? eve;
  double? morn;

  Temp({
    this.day,
    this.min,
    this.max,
    this.night,
    this.eve,
    this.morn,
  });

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        day: json["day"]?.toDouble(),
        min: json["min"]?.toDouble(),
        max: json["max"]?.toDouble(),
        night: json["night"]?.toDouble(),
        eve: json["eve"]?.toDouble(),
        morn: json["morn"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "min": min,
        "max": max,
        "night": night,
        "eve": eve,
        "morn": morn,
      };
}

class Minutely {
  int? dt;
  int? precipitation;

  Minutely({
    this.dt,
    this.precipitation,
  });

  factory Minutely.fromJson(Map<String, dynamic> json) => Minutely(
        dt: json["dt"],
        precipitation: json["precipitation"],
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "precipitation": precipitation,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map, this.reverseMap);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
