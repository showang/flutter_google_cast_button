#import "FlutterGoogleCastButtonPlugin.h"
#import <flutter_google_cast_button/flutter_google_cast_button-Swift.h>

@implementation FlutterGoogleCastButtonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGoogleCastButtonPlugin registerWithRegistrar:registrar];
}
@end
