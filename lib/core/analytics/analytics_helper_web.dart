import 'dart:js_interop';
import 'analytics_helper.dart';

@JS('trackGameMode')
external void _trackGameMode(JSString mode);

@JS('trackPageVisit')
external void _trackPageVisit(JSString pageName);

class AnalyticsHelperImpl implements AnalyticsHelper {
  @override
  void trackGameStart(String mode) {
    try {
      _trackGameMode(mode.toJS);
    } catch (e) {
      // Prevent crash if JS function is not defined
    }
  }

  @override
  void trackPageVisit(String pageName) {
    try {
      _trackPageVisit(pageName.toJS);
    } catch (e) {
      // Prevent crash if JS function is not defined
    }
  }
}

AnalyticsHelper getAnalyticsHelper() => AnalyticsHelperImpl();
