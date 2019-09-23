![pub](https://img.shields.io/pub/v/flutter_google_cast_button.svg)
# flutter_google_cast_button

A Flutter plugin provides a cast button widget and sync cast state with it.

# Use this package as a library
## Install

### 1. Depend on it
Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_google_cast_button: {last_version}
```

### 2. Install it
You can install packages from the command line:

with pub:

```console
$ pub get
```
with Flutter:

```console
$ flutter packages get
```
Alternatively, your editor might support pub get or flutter packages get. Check the docs for your editor to learn more.

## Android Settings

### 0. Support AndroidX
Add following properties to `gradle.properties`. 
``` properties
android.useAndroidX=true
android.enableJetifier=true
```
### 1. Add google cast dependency
Add `play-services-cast-framework` dependency into `android/build.gradle`
``` groovy
implementation "com.google.android.gms:play-services-cast-framework:16.2.0"
``` 

### 2. Create CastOptionsProvider class for configure cast library
``` kotlin
class DefaultCastOptionsProvider : OptionsProvider {
    override fun getCastOptions(context: Context): CastOptions {
        return CastOptions.Builder()
                .setReceiverApplicationId(CastMediaControlIntent.DEFAULT_MEDIA_RECEIVER_APPLICATION_ID)
                .build()
    }

    override fun getAdditionalSessionProviders(context: Context): List<SessionProvider>? {
        return null
    }
}
```
### 3. Add options provider metadata
Add `meta-data` to project's `AndroidManifest.xml`

``` xml
<meta-data
    android:name="com.google.android.gms.cast.framework.OPTIONS_PROVIDER_CLASS_NAME"
    android:value="github.showang.flutter_google_cast_button_example.DefaultCastOptionsProvider" />
``` 

### 4. Updating in live cycle
Add following code into `MainActivity` for update new state when resume.

``` kotlin
override fun onResume() {
    super.onResume()
    FlutterGoogleCastButtonPlugin.instance?.onResume()
}
``` 

## iOS settings

1. Get packages
Run `pod install` before open Xcode.

2. Initializing CastContext when `application didFinishLaunching`. EX:
``` swift
  let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
  let kDebugLoggingEnabled = true

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
  	let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
  	let options = GCKCastOptions(discoveryCriteria: criteria)
  	GCKCastContext.setSharedInstanceWith(options)

  	// Enable logger.
  	GCKLogger.sharedInstance().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Usage in Dart

### 1. Import it
Package paths relative with button widget.
```dart
import 'package:flutter_google_cast_button/bloc_media_route.dart';
import 'package:flutter_google_cast_button/cast_button_widget.dart';
```

### 2. Init MediaRouteBloc
Initialize/Dispose bloc when scope of widget's life cycle for saving/release state.

``` dart
MediaRouteBloc _mediaRouteBloc;

@override
void initState() {
  super.initState();
  mediaRouteBloc = MediaRouteBloc();
}

@override
void dispose() {
  mediaRouteBloc.dispose();
  super.dispose();
}

```

### 3. Provide MediaRouteBloc
Using bloc provider or any injection frameworks what you prefer.

#### BlocProvider Example
Provide a bloc.
``` dart
var widgetTree = new BlocProvider(
  bloc: _mediaRouteBloc,
  child: WidgetDependentWithBloc(),
);
```

### 4. Use the CastButtonWidget
If you are using BlocProvider.

``` dart
var _castButtonWidget = new CastButtonWidget();
```
else, inject the bloc for widget.
``` dart
var _castButtonWidget = new CastButtonWidget(bloc: _mediaRouteBloc);  
```