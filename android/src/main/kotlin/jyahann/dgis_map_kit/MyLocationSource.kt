package com.example.dgis_flutter

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Looper
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.*
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.positioning.DesiredAccuracy
import ru.dgis.sdk.positioning.LocationChangeListener
import ru.dgis.sdk.positioning.LocationSource

class MyLocationSource(private val applicationContext: Context, methodChannel: MethodChannel): LocationSource {
    private var methodChannel: MethodChannel
    private var fuseClient: FusedLocationProviderClient? = null
    private var fuseCallback: LocationCallback? = null
    private var sdkListener: LocationChangeListener? = null
    private var lastRequestedAccuracy: DesiredAccuracy = DesiredAccuracy.LOW

    init {
        this.methodChannel = methodChannel
    }

    override fun activate(listener: LocationChangeListener) {
        deactivate()

        sdkListener = listener

        if (checkPermission()) {
            // todo: request here
            return
        }
        fuseClient = LocationServices.getFusedLocationProviderClient(applicationContext)
        setDesiredAccuracy(lastRequestedAccuracy)
    }

    override fun deactivate() {
        fuseClient?.let {
            fuseCallback?.let(it::removeLocationUpdates)
        }
        fuseCallback = null
        fuseClient = null
        sdkListener = null
    }

    override fun setDesiredAccuracy(accuracy: DesiredAccuracy) {
        if (accuracy == lastRequestedAccuracy && fuseCallback != null)
            return

        lastRequestedAccuracy = accuracy

        val client = fuseClient ?: return
        val listener = sdkListener ?: return

        fuseCallback?.let(client::removeLocationUpdates)

        val newPriority = when (accuracy) {
            DesiredAccuracy.HIGH -> LocationRequest.PRIORITY_HIGH_ACCURACY
            DesiredAccuracy.MEDIUM -> LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
            DesiredAccuracy.LOW -> LocationRequest.PRIORITY_LOW_POWER
        }
        val request = LocationRequest.create().apply {
            priority = newPriority
            interval = 100L
        }
        val callback = (object: LocationCallback() {
            override fun onLocationResult(p0: LocationResult) {
                val location = p0 ?: return
                if (location.lastLocation != null) {
                    methodChannel.invokeMethod("user#locationChanged", mapOf<String, Double>(
                        "lat" to location.lastLocation!!.latitude,
                        "long" to location.lastLocation!!.longitude,
                    ))
                }
                // todo: avoid collection change
                listener.onLocationChanged(location.locations.toTypedArray())
            }
        }).also {
            fuseCallback = it
        }

        if (checkPermission()) {
            return
        }
        client.requestLocationUpdates(request, callback, Looper.getMainLooper())
        listener.onAvailabilityChanged(true)

    }

    private fun checkPermission(): Boolean = ActivityCompat.checkSelfPermission(
        applicationContext,
        Manifest.permission.ACCESS_FINE_LOCATION
    ) != PackageManager.PERMISSION_GRANTED

}