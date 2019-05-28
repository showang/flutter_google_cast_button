import Flutter
import UIKit
import GoogleCast

public class SwiftFlutterGoogleCastButtonPlugin: NSObject, FlutterPlugin {
	
	private static var eventSink: FlutterEventSink? = nil
	let castContext = GCKCastContext.sharedInstance()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_google_cast_button", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterGoogleCastButtonPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
	
	let eventChannel = FlutterEventChannel(name: "cast_state_event", binaryMessenger: registrar.messenger())
	eventChannel.setStreamHandler(CastEventHandler())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
	
	switch call.method {
	case "showCastDialog":
		castContext.presentCastDialog()
	default:
		print("Method [\(call.method)] is not implemented.")
	}
	
//    result("iOS " + UIDevice.current.systemVersion)
  }
	
	
	class CastEventHandler: NSObject,FlutterStreamHandler {
		
		let castContext = GCKCastContext.sharedInstance()
		var lastState = GCKCastState.notConnected
		var stateObserver: NSKeyValueObservation?
		
		public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
			SwiftFlutterGoogleCastButtonPlugin.eventSink = events
			stateObserver = castContext.observe(\.castState, options: [.new, .old, .initial]){ (state, change) in
				self.lastState = self.castContext.castState
				print("cast state change to: \(self.lastState.rawValue)")
				SwiftFlutterGoogleCastButtonPlugin.eventSink?(self.lastState.rawValue + 1)
			}
			//		SwiftFlutterPartnerPlayerPlugin.castEventSink?(lastState.rawValue)
			return nil
		}
		
		public func onCancel(withArguments arguments: Any?) -> FlutterError? {
			stateObserver?.invalidate()
			stateObserver = nil
			SwiftFlutterGoogleCastButtonPlugin.eventSink = nil
			return nil
		}
		
	}

}

