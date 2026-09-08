package com.zelixa.zelixaquran

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class JadwalShalatWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateSingleAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "ZelixaWidgetPrefs"

        fun updateSingleAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val city = prefs.getString("city", "Jakarta") ?: "Jakarta"
            val date = prefs.getString("date", "Hari ini") ?: "Hari ini"
            val nextName = prefs.getString("nextPrayerName", "Waktu Shalat") ?: "Waktu Shalat"
            val nextTime = prefs.getString("nextPrayerTime", "--:-- WIB") ?: "--:-- WIB"
            val subuh = prefs.getString("subuh", "--:--") ?: "--:--"
            val dzuhur = prefs.getString("dzuhur", "--:--") ?: "--:--"
            val ashar = prefs.getString("ashar", "--:--") ?: "--:--"
            val maghrib = prefs.getString("maghrib", "--:--") ?: "--:--"
            val isya = prefs.getString("isya", "--:--") ?: "--:--"

            val views = RemoteViews(context.packageName, R.layout.widget_jadwal_shalat)

            views.setTextViewText(R.id.tv_widget_city, city)
            views.setTextViewText(R.id.tv_widget_date, "• $date")
            views.setTextViewText(R.id.tv_widget_next_name, nextName)
            views.setTextViewText(R.id.tv_widget_next_time, nextTime)

            views.setTextViewText(R.id.tv_widget_subuh, subuh)
            views.setTextViewText(R.id.tv_widget_dzuhur, dzuhur)
            views.setTextViewText(R.id.tv_widget_ashar, ashar)
            views.setTextViewText(R.id.tv_widget_maghrib, maghrib)
            views.setTextViewText(R.id.tv_widget_isya, isya)

            // Open app on widget click
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        fun updateAllWidgets(context: Context, data: Map<String, String>) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val editor = prefs.edit()
            for ((k, v) in data) {
                editor.putString(k, v)
            }
            editor.apply()

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, JadwalShalatWidget::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

            for (appWidgetId in appWidgetIds) {
                updateSingleAppWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }
}
