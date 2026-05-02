package com.nls.weatherapp

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.concurrent.thread
import kotlin.math.roundToInt
import org.json.JSONObject

class WeatherWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        WeatherWidgetUpdater.updateWidgets(context)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            WeatherWidgetUpdater.ACTION_REFRESH -> WeatherWidgetUpdater.refreshWeather(context)
            WeatherWidgetUpdater.ACTION_REFRESH_AVAILABLE -> WeatherWidgetUpdater.updateWidgets(context)
        }
    }
}

object WeatherWidgetUpdater {
    const val ACTION_REFRESH = "com.nls.weatherapp.weather_widget.REFRESH"
    const val ACTION_REFRESH_AVAILABLE = "com.nls.weatherapp.weather_widget.REFRESH_AVAILABLE"

    private const val PREFS = "weather_widget_prefs"
    private const val KEY_DATA = "data"
    private const val KEY_LAST_UPDATED = "last_updated"
    private const val KEY_LATITUDE = "latitude"
    private const val KEY_LONGITUDE = "longitude"
    private const val KEY_API_BASE_URL = "api_base_url"
    private const val KEY_API_KEY = "api_key"
    private const val REFRESH_AFTER_MS = 3L * 60L * 60L * 1000L

    fun saveFromFlutter(context: Context, payload: Map<String, Any?>?) {
        if (payload == null) return

        val data = JSONObject(payload).toString()
        val latitude = (payload["latitude"] as? Number)?.toFloat()
        val longitude = (payload["longitude"] as? Number)?.toFloat()
        val lastUpdated = (payload["lastUpdated"] as? Number)?.toLong()
            ?: System.currentTimeMillis()

        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_DATA, data)
            .putLong(KEY_LAST_UPDATED, lastUpdated)
            .putFloat(KEY_LATITUDE, latitude ?: Float.NaN)
            .putFloat(KEY_LONGITUDE, longitude ?: Float.NaN)
            .putString(KEY_API_BASE_URL, payload["apiBaseUrl"] as? String)
            .putString(KEY_API_KEY, payload["apiKey"] as? String)
            .apply()

        updateWidgets(context)
        scheduleRefreshButton(context, lastUpdated)
    }

    fun refreshWeather(context: Context) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val lastUpdated = prefs.getLong(KEY_LAST_UPDATED, 0L)
        val now = System.currentTimeMillis()

        if (!isRefreshAllowed(lastUpdated, now)) {
            updateWidgets(context)
            scheduleRefreshButton(context, lastUpdated)
            return
        }

        val latitude = prefs.getFloat(KEY_LATITUDE, Float.NaN)
        val longitude = prefs.getFloat(KEY_LONGITUDE, Float.NaN)
        val apiBaseUrl = prefs.getString(KEY_API_BASE_URL, null).orEmpty()
        val apiKey = prefs.getString(KEY_API_KEY, null).orEmpty()

        if (latitude.isNaN() || longitude.isNaN() || apiBaseUrl.isBlank() || apiKey.isBlank()) {
            updateWidgets(context, "Open the app once to enable refresh")
            return
        }

        updateWidgets(context, "Refreshing...")

        thread {
            try {
                val url = buildWeatherUrl(apiBaseUrl, latitude.toDouble(), longitude.toDouble(), apiKey)
                val response = url.openConnection().run {
                    connectTimeout = 12000
                    readTimeout = 12000
                    getInputStream().bufferedReader().use { it.readText() }
                }
                val data = buildWidgetDataFromApi(JSONObject(response), prefs.getString(KEY_DATA, null))

                prefs.edit()
                    .putString(KEY_DATA, data.toString())
                    .putLong(KEY_LAST_UPDATED, System.currentTimeMillis())
                    .apply()

                updateWidgets(context, "Updated now")
                scheduleRefreshButton(context, System.currentTimeMillis())
            } catch (_: Exception) {
                updateWidgets(context, "Refresh failed")
            }
        }
    }

    fun updateWidgets(context: Context, statusOverride: String? = null) {
        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, WeatherWidgetProvider::class.java)
        val widgetIds = manager.getAppWidgetIds(component)
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val data = prefs.getString(KEY_DATA, null)

        widgetIds.forEach { widgetId ->
            manager.updateAppWidget(widgetId, createRemoteViews(context, data, statusOverride))
        }
    }

    private fun createRemoteViews(
        context: Context,
        data: String?,
        statusOverride: String?
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.weather_widget)

        views.setOnClickPendingIntent(R.id.widget_refresh_button, refreshPendingIntent(context))
        views.setOnClickPendingIntent(R.id.widget_root, openAppPendingIntent(context))

        if (data.isNullOrBlank()) {
            views.setTextViewText(R.id.widget_city, "Weather Lite")
            views.setTextViewText(R.id.widget_temperature, "--")
            views.setTextViewText(R.id.widget_condition, "Open app to load weather")
            views.setTextViewText(R.id.widget_meta, "Today")
            views.setTextViewText(R.id.widget_today_range, "--")
            views.setTextViewText(R.id.widget_details, "--")
            views.setViewVisibility(R.id.widget_refresh_button, View.GONE)
            return views
        }

        val json = JSONObject(data)
        val current = json.optJSONObject("current") ?: JSONObject()
        val today = json.optJSONObject("today") ?: JSONObject()
        val lastUpdated = json.optLong("lastUpdated", 0L)
        val canRefresh = isRefreshAllowed(lastUpdated, System.currentTimeMillis())

        views.setTextViewText(R.id.widget_city, json.optString("city", "Weather Lite"))
        views.setTextViewText(R.id.widget_temperature, "${current.optDouble("temp", 0.0).round()}\u00B0C")
        views.setTextViewText(
            R.id.widget_condition,
            current.optString("description", "Current").titlecase()
        )

        val status = statusOverride ?: if (lastUpdated > 0L) {
            "Updated ${SimpleDateFormat("h:mm a", Locale.getDefault()).format(Date(lastUpdated))}"
        } else {
            "Today"
        }
        views.setTextViewText(R.id.widget_meta, status)
        views.setTextViewText(
            R.id.widget_today_range,
            "Today ${today.optDouble("max", 0.0).round()}\u00B0 / ${today.optDouble("min", 0.0).round()}\u00B0"
        )
        views.setTextViewText(
            R.id.widget_details,
            "Feels ${current.optDouble("feelsLike", 0.0).round()}\u00B0  Humidity ${current.optInt("humidity", today.optInt("humidity", 0))}%"
        )
        views.setViewVisibility(
            R.id.widget_refresh_button,
            if (canRefresh) View.VISIBLE else View.GONE
        )

        if (!canRefresh) {
            scheduleRefreshButton(context, lastUpdated)
        }

        return views
    }

    private fun buildWeatherUrl(
        apiBaseUrl: String,
        latitude: Double,
        longitude: Double,
        apiKey: String
    ): java.net.URL {
        val normalizedBaseUrl = if (apiBaseUrl.startsWith("http")) apiBaseUrl else "https://$apiBaseUrl"
        val uri = Uri.parse(normalizedBaseUrl).buildUpon()
            .appendQueryParameter("lat", latitude.toString())
            .appendQueryParameter("lon", longitude.toString())
            .appendQueryParameter("units", "metric")
            .appendQueryParameter("exclude", "minutely")
            .appendQueryParameter(
                "date",
                SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
            )
            .appendQueryParameter("appid", apiKey)
            .build()

        return java.net.URL(uri.toString())
    }

    private fun buildWidgetDataFromApi(response: JSONObject, previousData: String?): JSONObject {
        val previous = previousData?.let { JSONObject(it) } ?: JSONObject()
        val current = response.optJSONObject("current") ?: JSONObject()
        val currentWeather = current.optJSONArray("weather")?.optJSONObject(0) ?: JSONObject()
        val todaySource = response.optJSONArray("daily")?.optJSONObject(0) ?: JSONObject()
        val todayTemp = todaySource.optJSONObject("temp") ?: JSONObject()
        val todayWeather = todaySource.optJSONArray("weather")?.optJSONObject(0) ?: JSONObject()

        return JSONObject()
            .put("city", previous.optString("city", "Weather Lite"))
            .put("lastUpdated", System.currentTimeMillis())
            .put(
                "current",
                JSONObject()
                    .put("temp", current.optDouble("temp"))
                    .put("feelsLike", current.optDouble("feels_like"))
                    .put("humidity", current.optInt("humidity"))
                    .put("windSpeed", current.optDouble("wind_speed"))
                    .put("main", currentWeather.optString("main", "Weather"))
                    .put("description", currentWeather.optString("description", "Current"))
            )
            .put(
                "today",
                JSONObject()
                    .put("dt", todaySource.optLong("dt"))
                    .put("min", todayTemp.optDouble("min"))
                    .put("max", todayTemp.optDouble("max"))
                    .put("humidity", todaySource.optInt("humidity"))
                    .put("windSpeed", todaySource.optDouble("wind_speed"))
                    .put("main", todayWeather.optString("main", "Weather"))
                    .put("description", todayWeather.optString("description", "Forecast"))
            )
    }

    private fun String.titlecase(): String {
        return split(" ").joinToString(" ") { word ->
            word.replaceFirstChar {
                if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
            }
        }
    }

    private fun Double.round(): String {
        return roundToInt().toString()
    }

    private fun isRefreshAllowed(lastUpdated: Long, now: Long): Boolean {
        return lastUpdated == 0L || now - lastUpdated >= REFRESH_AFTER_MS
    }

    private fun scheduleRefreshButton(context: Context, lastUpdated: Long) {
        if (lastUpdated <= 0L || isRefreshAllowed(lastUpdated, System.currentTimeMillis())) return

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(refreshAvailablePendingIntent(context))
        alarmManager.set(
            AlarmManager.RTC,
            lastUpdated + REFRESH_AFTER_MS,
            refreshAvailablePendingIntent(context)
        )
    }

    private fun refreshPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, WeatherWidgetProvider::class.java).apply {
            action = ACTION_REFRESH
        }
        return PendingIntent.getBroadcast(
            context,
            1201,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun openAppPendingIntent(context: Context): PendingIntent {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: Intent()
        return PendingIntent.getActivity(
            context,
            1202,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun refreshAvailablePendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, WeatherWidgetProvider::class.java).apply {
            action = ACTION_REFRESH_AVAILABLE
        }
        return PendingIntent.getBroadcast(
            context,
            1203,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
