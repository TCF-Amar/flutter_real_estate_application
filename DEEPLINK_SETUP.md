# Deep Link Setup & Architecture

This document serves as a senior developer guide for the Deep Link architecture implemented in this application. It covers how Android App Links (HTTPS) and Custom URI schemes are configured, parsed, and handled across both cold-start and warm-start lifecycles using `app_links` and GetX.

## 1. Android Manifest Configuration

Deep links require `intent-filter` blocks within the `<activity>` tag of your `android/app/src/main/AndroidManifest.xml`. 

> [!IMPORTANT]
> Keep deep link intent filters specific. Using `<data android:pathPrefix="/" />` will capture every single link for that domain and route it to the app, which might break standard web browsing logic. Always scope them securely (e.g., `/property`, `/agent`).

### App Links (HTTPS)
App Links are the heavily preferred standard on Android and iOS. They require server-side domain verification (e.g., `assetlinks.json`).

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="https" android:host="backend-realstate.hktechlabs.com" android:pathPrefix="/property"/>
</intent-filter>
```
*Note: Without `assetlinks.json` hosted on your domain, `autoVerify="true"` will fail silently and Android will fall back to opening the web browser instead of the app.*

### Custom URI Schemes
Custom schemas (`realestate://`) are excellent as an un-blockable fallback and for local development, as they do not require domain verification and work 100% of the time, provided the user has the app installed.

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="realestate"/>
</intent-filter>
```

---

## 2. The `DeepLinkService` Architecture (GetxService)

We use a central `DeepLinkService` (registered in `InitialDi`) to capture incoming URIs. The service manages two entirely different app lifecycles:

### Warm-Start / Hot-Start
The app is already alive in the background. We listen to `_appLinks.uriLinkStream`. This stream intercepts the URI, and since the navigation stack is already fully built, it can execute `Get.toNamed()` immediately.

### Cold-Start Race Condition
When the app is entirely killed, clicking a deep link launches it. 
> [!CAUTION]  
> If GetX attempts to route (`Get.toNamed`) inside `main()` or during the Splash Screen building phase, it will crash or fall back to the generic `/` route, because the main auth/navigation stack hasn't initialized yet.

**The Fix:**
1. `DeepLinkService` reads `await _appLinks.getInitialLink()` during initialization.
2. If present, it stores it as `pendingUri` **without** performing any routing.
3. The app proceeds normally (`Splash` -> Auth Check -> `MainScreen`).
4. Inside `MainScreen`'s `initState`, we explicitly call `Get.find<DeepLinkService>().consumePending()`. Only at this point is the stack safe to manipulate.

---

## 3. Parsing `Uri` Object Differences

Dart evaluates the `Uri` class differently depending on the scheme structure. Our `DeepLinkRouter` parses the string accurately regardless of the protocol.

| Scenario | URI Example | `uri.host` | `uri.pathSegments` |
| :--- | :--- | :--- | :--- |
| **HTTPS** | `https://domain.com/property/55` | `domain.com` | `['property', '55']` |
| **Custom** | `realestate://property/55` | `property` | `['55']` |

**Routing Logic Snippet:**
```dart
if (uri.scheme == 'realestate') {
  section = uri.host;                                // 'property'
  id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
} else {
  section = uri.pathSegments.first;                  // 'property'
  id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null; 
}
```

---

## 4. GetX Controller Binding & Initialization Gotchas

If a screen handles deep links, it means users can jump into that page randomly, go back, and jump in again.

> [!WARNING]
> Do **not** use `Get.lazyPut(() => Controller(), fenix: true)` combined with `late final` fields in the controller. Fenix attempts to recycle the controller object instance, which will force `onInit()` to execute twice over the app lifecycle. `late final` variables crashes when assigned twice (`LateInitializationError`).

Use Standard dependency injection principles:
- Initialize dependencies immediately inline: `final PropertyServices _services = Get.find();`
- Use `Get.put(Controller(), permanent: false)` in your bindings to ensure a fresh clean slate every time the user enters the route via a Deep link.
- **`Get.arguments` Type Safety**: Deep links pass string parameters (e.g. `"55"`). Standard in-app `Get.toNamed` usually passes a structured dictionary (`{'id': 55}`). Ensure your controllers parse `Get.arguments` gracefully supporting both `String` and `Map`.

---

## 5. Developer Testing (ADB)

To test your handling logic without physically clicking links on a device simulator, use the Android Debug Bridge (ADB).

Find your exact `applicationId` inside `android/app/build.gradle.kts` (e.g. `com.example.real_estate_app`). Do **not** use the flutter project name.

**Test Cold/Warm Start using Custom Scheme:**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "realestate://property/55" com.example.real_estate_app
```

**Test HTTPS Verification:**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://backend-realstate.hktechlabs.com/property/10" com.example.real_estate_app
```

If you receive an intent error or the "Open With..." Android system disambiguation dialog, it typically means your ADB command string formatting is broken or there is a typo in your manifest XML. Ensure PowerShell strings are single-lined properly.
