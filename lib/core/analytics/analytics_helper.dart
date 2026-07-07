import 'analytics_helper_stub.dart'
    if (dart.library.js_interop) 'analytics_helper_web.dart';

abstract class AnalyticsHelper {
  void trackGameStart(String mode);
  void trackPageVisit(String pageName);
  void trackGameWon(String mode, int attempts);
  void trackGameLost(String mode, int attempts);

  static AnalyticsHelper get instance => getAnalyticsHelper();
}
