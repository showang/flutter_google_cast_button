package github.showang.flutter_google_cast_button

import android.util.Log
import androidx.annotation.StyleRes
import androidx.mediarouter.app.MediaRouteChooserDialog
import androidx.mediarouter.app.MediaRouteControllerDialog
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.CastState
import com.google.android.gms.cast.framework.CastStateListener
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterGoogleCastButtonPlugin(private val registrar: Registrar, private val castStreamHandler: CastStreamHandler) : MethodCallHandler {
    companion object {
        @StyleRes
        var customStyleResId: Int? = null
        var instance: FlutterGoogleCastButtonPlugin? = null

        private val themeResId get() = customStyleResId ?: R.style.DefaultCastDialogTheme

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val streamHandler = CastStreamHandler()
            instance = FlutterGoogleCastButtonPlugin(registrar, streamHandler)
            MethodChannel(registrar.messenger(), "flutter_google_cast_button").apply {
                setMethodCallHandler(instance)
            }
            EventChannel(registrar.messenger(), "cast_state_event").apply {
                setStreamHandler(streamHandler)
            }
        }

    }

    init {
        // Please note that getting the shared instance may throw exceptions while
        // the current device does not have Google Play service.
        try {
            CastContext.getSharedInstance(registrar.activeContext())
        } catch (e: Exception) {
            Log.v("Cast", "$e")
        }
    }

    private val castContext get() = CastContext.getSharedInstance(registrar.activeContext())

    fun onResume() {
        castStreamHandler.updateState()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "showCastDialog" -> showCastDialog()
            else -> result.notImplemented()
        }
    }

    private fun showCastDialog() {
        castContext.sessionManager.currentCastSession?.let {
            MediaRouteControllerDialog(registrar.activeContext(), themeResId)
                .show()
        } ?: run {
            MediaRouteChooserDialog(registrar.activeContext(), themeResId).apply {
                routeSelector = castContext.mergedSelector
                show()
            }
        }
    }
}

class CastStreamHandler : EventChannel.StreamHandler {

    private var lastState = CastState.NO_DEVICES_AVAILABLE
    private var eventSink: EventChannel.EventSink? = null
    private val castStateListener = CastStateListener { state ->
        lastState = state
        eventSink?.success(state)
    }

    override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
        val castContext = CastContext.getSharedInstance() ?: return
        eventSink = sink
        castContext.addCastStateListener(castStateListener)
        lastState = castContext.castState
        eventSink?.success(lastState)
    }

    override fun onCancel(p0: Any?) {
        val castContext = CastContext.getSharedInstance() ?: return
        castContext.removeCastStateListener(castStateListener)
        eventSink = null
    }

    fun updateState() {
        eventSink?.success(lastState)
    }

}