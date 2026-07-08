import 'package:flutter/foundation.dart';

/// Global override to simulate mobile browser environment in unit/widget tests.
bool isMobileBrowserOverrideForTesting = false;

/// Returns true if the app is running in a mobile web browser.
bool get isMobileBrowser =>
    isMobileBrowserOverrideForTesting ||
    (kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS));
