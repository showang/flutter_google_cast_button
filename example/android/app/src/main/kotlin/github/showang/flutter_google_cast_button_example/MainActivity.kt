package github.showang.flutter_google_cast_button_example

import android.os.Bundle
import github.showang.flutter_google_cast_button.FlutterGoogleCastButtonPlugin

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
    }

    override fun onResume() {
        super.onResume()
        //Update newest state when resume
        FlutterGoogleCastButtonPlugin.instance?.onResume()
    }

}
